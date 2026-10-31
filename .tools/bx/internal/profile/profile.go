// Package profile loads bx profiles and turns them into bwrap arguments.
//
// A profile is a file with one bwrap flag and its values per line. Lines are
// split like shell words, so values with spaces can be quoted. Text after #
// is a comment. Each word is expanded with $VAR and ${VAR} after splitting.
// The line "include <name>" inserts the lines of another profile.
//
// A local .bx file is parsed the same way, with two extras: $BX_DIR holds the
// file's directory, and a word that starts with "./" or "../" resolves
// against the file's directory. Neither applies to profiles it includes.
package profile

import (
	"errors"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
	"slices"
	"strings"

	"github.com/google/shlex"
)

// BaseName is the name of the profile that is always loaded first.
const BaseName = "base"

// CurrentDirName names the working directory's local .bx file in toggles.
const CurrentDirName = "."

// ParentDirName names the parent directories' local .bx files in toggles.
const ParentDirName = ".."

const includeDirective = "include"

// ErrIncludeCycle is returned when profiles include each other in a loop.
var ErrIncludeCycle = errors.New("include cycle")

// Env returns the variable lookup for profile expansion. PWD always holds
// wd, the real working directory, even when the caller did not set it.
func Env(wd string) func(key string) string {
	return func(key string) string {
		if key == "PWD" {
			return wd
		}
		return os.Getenv(key)
	}
}

// Loader reads profiles from a directory.
type Loader struct {
	// Dir is the directory that holds the profile files.
	Dir string
	// Getenv returns the value of a variable used in a profile.
	Getenv func(key string) string
	// Disable names profiles that are never loaded, even from includes.
	Disable []string
	// Skipped records each profile that was skipped because it is disabled.
	Skipped []string
}

// Resolve returns the bwrap arguments for a command.
//
// The base profile is loaded first when it exists, then the profile named
// after the base name of command when it exists, then each enable profile in
// order. Each name is loaded once; disabled names are skipped. The special
// names "." and ".." refer to local files, so Resolve ignores them.
func (l *Loader) Resolve(enable []string, command string) ([]string, error) {
	for _, name := range l.Disable {
		if name == CurrentDirName || name == ParentDirName {
			continue
		}
		ok, err := l.exists(name)
		if err != nil {
			return nil, err
		}
		if !ok {
			return nil, fmt.Errorf("unknown profile %q", name)
		}
	}

	names, err := l.selectProfiles(enable, command)
	if err != nil {
		return nil, err
	}

	var args []string
	for _, name := range names {
		profileArgs, err := l.load(name, nil)
		if err != nil {
			return nil, err
		}
		args = append(args, profileArgs...)
	}
	return args, nil
}

// selectProfiles returns the ordered profile names to load, each name once.
func (l *Loader) selectProfiles(enable []string, command string) ([]string, error) {
	var names []string
	add := func(name string) {
		if !slices.Contains(names, name) {
			names = append(names, name)
		}
	}

	hasBase, err := l.exists(BaseName)
	if err != nil {
		return nil, err
	}
	if hasBase {
		add(BaseName)
	}

	if command != "" {
		name := filepath.Base(command)
		ok, err := l.exists(name)
		if err != nil {
			return nil, err
		}
		if ok {
			add(name)
		}
	}

	for _, name := range enable {
		if name == CurrentDirName || name == ParentDirName {
			continue
		}
		add(name)
	}
	return names, nil
}

// Load returns the bwrap arguments of the named profile and its includes.
func (l *Loader) Load(name string) ([]string, error) {
	return l.load(name, nil)
}

// LoadFile returns the bwrap arguments of a local profile file.
//
// $BX_DIR expands to the file's directory, and a word that starts with "./"
// or "../" resolves against that directory. Includes load from the loader's
// Dir and get neither extra.
func (l *Loader) LoadFile(path string) ([]string, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("local profile %s: %w", path, err)
	}

	dir := filepath.Dir(path)
	getenv := func(key string) string {
		if key == "BX_DIR" {
			return dir
		}
		return l.Getenv(key)
	}
	return l.parse(path, string(data), []string{path}, getenv, dir)
}

// LoadFiles returns the combined bwrap arguments of local profile files,
// loading each with LoadFile in order.
func (l *Loader) LoadFiles(paths []string) ([]string, error) {
	var args []string
	for _, path := range paths {
		fileArgs, err := l.LoadFile(path)
		if err != nil {
			return nil, err
		}
		args = append(args, fileArgs...)
	}
	return args, nil
}

func (l *Loader) load(name string, chain []string) ([]string, error) {
	if slices.Contains(l.Disable, name) {
		l.Skipped = append(l.Skipped, name)
		return nil, nil
	}

	chain = append(chain, name)
	if slices.Contains(chain[:len(chain)-1], name) {
		return nil, fmt.Errorf("%w: %s", ErrIncludeCycle, strings.Join(chain, " -> "))
	}

	path := l.path(name)
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("profile %q: %w", name, err)
	}
	return l.parse(path, string(data), chain, l.Getenv, "")
}

// parse turns profile lines into bwrap arguments. Words expand with getenv.
// A non-empty localDir marks a local file: words that start with "./" or
// "../" resolve against it. Includes always go through load, so they get the
// loader's plain Getenv and no path resolution.
func (l *Loader) parse(path, data string, chain []string, getenv func(string) string, localDir string) ([]string, error) {
	var args []string
	lineNo := 0
	for line := range strings.Lines(data) {
		lineNo++
		words, err := shlex.Split(line)
		if err != nil {
			return nil, fmt.Errorf("%s:%d: %w", path, lineNo, err)
		}
		if len(words) == 0 {
			continue
		}

		if words[0] != includeDirective {
			args = append(args, expand(words, getenv, localDir)...)
			continue
		}

		if len(words) != 2 {
			return nil, fmt.Errorf("%s:%d: include needs exactly one profile name", path, lineNo)
		}
		if words[1] == CurrentDirName || words[1] == ParentDirName {
			return nil, fmt.Errorf(`%s:%d: "." and ".." name local files and cannot be included`, path, lineNo)
		}
		included, err := l.load(words[1], chain)
		if err != nil {
			return nil, err
		}
		args = append(args, included...)
	}
	return args, nil
}

func expand(words []string, getenv func(string) string, localDir string) []string {
	expanded := make([]string, len(words))
	for i, word := range words {
		word = os.Expand(word, getenv)
		if localDir != "" && (strings.HasPrefix(word, "./") || strings.HasPrefix(word, "../")) {
			word = filepath.Join(localDir, word)
		}
		expanded[i] = word
	}
	return expanded
}

func (l *Loader) exists(name string) (bool, error) {
	_, err := os.Stat(l.path(name))
	if errors.Is(err, fs.ErrNotExist) {
		return false, nil
	}
	if err != nil {
		return false, fmt.Errorf("profile %q: %w", name, err)
	}
	return true, nil
}

func (l *Loader) path(name string) string {
	return filepath.Join(l.Dir, name)
}
