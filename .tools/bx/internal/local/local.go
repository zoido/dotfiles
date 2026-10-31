// Package local discovers .bx profile files in the working directory and its
// parents.
package local

import (
	"errors"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
)

// FileName is the name of a local profile file.
const FileName = ".bx"

// Files holds the local profile files found for a directory.
type Files struct {
	// Parents are the .bx files of the parent directories, outermost first.
	Parents []string
	// Current is the .bx file of the directory itself, or empty.
	Current string
}

// Select splits the files into the paths to load and the paths that the
// disabled toggles skip, both in load order.
func (f Files) Select(skipParents, skipCurrent bool) (paths, skipped []string) {
	if skipParents {
		skipped = append(skipped, f.Parents...)
	} else {
		paths = append(paths, f.Parents...)
	}
	if f.Current != "" {
		if skipCurrent {
			skipped = append(skipped, f.Current)
		} else {
			paths = append(paths, f.Current)
		}
	}
	return paths, skipped
}

// Find returns the .bx files from the root down to dir. Only regular files
// and symlinks to regular files count; directories are skipped.
func Find(dir string) (Files, error) {
	dir, err := filepath.Abs(dir)
	if err != nil {
		return Files{}, err
	}

	var chain []string
	for {
		chain = append(chain, dir)
		parent := filepath.Dir(dir)
		if parent == dir {
			break
		}
		dir = parent
	}

	var files Files
	for i := len(chain) - 1; i >= 0; i-- {
		path := filepath.Join(chain[i], FileName)
		ok, err := isFile(path)
		if err != nil {
			return Files{}, err
		}
		if !ok {
			continue
		}
		if i == 0 {
			files.Current = path
		} else {
			files.Parents = append(files.Parents, path)
		}
	}
	return files, nil
}

func isFile(path string) (bool, error) {
	info, err := os.Stat(path)
	if errors.Is(err, fs.ErrNotExist) {
		return false, nil
	}
	if err != nil {
		return false, fmt.Errorf("local profile %s: %w", path, err)
	}
	return info.Mode().IsRegular(), nil
}
