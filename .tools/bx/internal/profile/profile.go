// Package profile loads bx profiles and turns them into bwrap arguments.
//
// A profile is a file with one bwrap flag and its values per line. Lines are
// split like shell words, so values with spaces can be quoted. Text after #
// is a comment. Each word is expanded with $VAR and ${VAR} after splitting.
// The line "include <name>" inserts the lines of another profile.
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

const includeDirective = "include"

// ErrIncludeCycle is returned when profiles include each other in a loop.
var ErrIncludeCycle = errors.New("include cycle")

// Loader reads profiles from a directory.
type Loader struct {
	// Dir is the directory that holds the profile files.
	Dir string
	// Getenv returns the value of a variable used in a profile.
	Getenv func(key string) string
}

// Resolve returns the bwrap arguments for a command.
//
// The base profile is loaded first when it exists. Then the explicit profile
// is loaded, or, when explicit is empty, the profile named after the base
// name of command when it exists.
func (l Loader) Resolve(explicit, command string) ([]string, error) {
	var args []string

	hasBase, err := l.exists(BaseName)
	if err != nil {
		return nil, err
	}
	if hasBase {
		baseArgs, err := l.Load(BaseName)
		if err != nil {
			return nil, err
		}
		args = append(args, baseArgs...)
	}

	name, err := l.selectProfile(explicit, command)
	if err != nil {
		return nil, err
	}
	if name == "" || name == BaseName {
		return args, nil
	}

	profileArgs, err := l.Load(name)
	if err != nil {
		return nil, err
	}
	return append(args, profileArgs...), nil
}

func (l Loader) selectProfile(explicit, command string) (string, error) {
	if explicit != "" {
		return explicit, nil
	}
	if command == "" {
		return "", nil
	}

	name := filepath.Base(command)
	ok, err := l.exists(name)
	if err != nil || !ok {
		return "", err
	}
	return name, nil
}

// Load returns the bwrap arguments of the named profile and its includes.
func (l Loader) Load(name string) ([]string, error) {
	return l.load(name, nil)
}

func (l Loader) load(name string, chain []string) ([]string, error) {
	chain = append(chain, name)
	if slices.Contains(chain[:len(chain)-1], name) {
		return nil, fmt.Errorf("%w: %s", ErrIncludeCycle, strings.Join(chain, " -> "))
	}

	path := l.path(name)
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("profile %q: %w", name, err)
	}

	var args []string
	lineNo := 0
	for line := range strings.Lines(string(data)) {
		lineNo++
		words, err := shlex.Split(line)
		if err != nil {
			return nil, fmt.Errorf("%s:%d: %w", path, lineNo, err)
		}
		if len(words) == 0 {
			continue
		}

		if words[0] != includeDirective {
			args = append(args, l.expand(words)...)
			continue
		}

		if len(words) != 2 {
			return nil, fmt.Errorf("%s:%d: include needs exactly one profile name", path, lineNo)
		}
		included, err := l.load(words[1], chain)
		if err != nil {
			return nil, err
		}
		args = append(args, included...)
	}
	return args, nil
}

func (l Loader) expand(words []string) []string {
	expanded := make([]string, len(words))
	for i, word := range words {
		expanded[i] = os.Expand(word, l.Getenv)
	}
	return expanded
}

func (l Loader) exists(name string) (bool, error) {
	_, err := os.Stat(l.path(name))
	if errors.Is(err, fs.ErrNotExist) {
		return false, nil
	}
	if err != nil {
		return false, fmt.Errorf("profile %q: %w", name, err)
	}
	return true, nil
}

func (l Loader) path(name string) string {
	return filepath.Join(l.Dir, name)
}
