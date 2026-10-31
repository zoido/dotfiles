package local_test

import (
	"os"
	"path/filepath"
	"slices"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"bx/internal/local"
)

func TestFind(t *testing.T) {
	type testCase struct {
		// files are paths relative to the temporary root that get a .bx file.
		files []string
		// dirs are paths relative to the temporary root that get a .bx directory.
		dirs []string
		// symlinks maps a relative .bx path to a relative file target.
		symlinks map[string]string
		// start is the start directory relative to the temporary root.
		start string
		// wantParents are the expected parent .bx files relative to the root.
		wantParents []string
		// wantCurrent is the expected current .bx file relative to the root.
		wantCurrent string
	}

	run := func(t *testing.T, tc testCase) {
		// Given
		root := t.TempDir()
		if err := os.MkdirAll(filepath.Join(root, tc.start), 0o700); err != nil {
			t.Fatal(err)
		}
		for _, dir := range tc.files {
			path := filepath.Join(root, dir, local.FileName)
			if err := os.MkdirAll(filepath.Dir(path), 0o700); err != nil {
				t.Fatal(err)
			}
			if err := os.WriteFile(path, []byte("--share-net\n"), 0o600); err != nil {
				t.Fatal(err)
			}
		}
		for _, dir := range tc.dirs {
			if err := os.MkdirAll(filepath.Join(root, dir, local.FileName), 0o700); err != nil {
				t.Fatal(err)
			}
		}
		for link, target := range tc.symlinks {
			targetPath := filepath.Join(root, target)
			if err := os.WriteFile(targetPath, []byte("--share-net\n"), 0o600); err != nil {
				t.Fatal(err)
			}
			if err := os.Symlink(targetPath, filepath.Join(root, link, local.FileName)); err != nil {
				t.Fatal(err)
			}
		}

		// When
		got, err := local.Find(filepath.Join(root, tc.start))

		// Then
		require.NoError(t, err)

		// The walk reaches /, so keep only paths under the temporary root.
		gotParents := slices.DeleteFunc(got.Parents, func(path string) bool {
			rel, err := filepath.Rel(root, path)
			return err != nil || !filepath.IsLocal(rel)
		})
		var wantParents []string
		for _, dir := range tc.wantParents {
			wantParents = append(wantParents, filepath.Join(root, dir, local.FileName))
		}
		assert.Equal(t, wantParents, gotParents)

		wantCurrent := ""
		if tc.wantCurrent != "" {
			wantCurrent = filepath.Join(root, tc.wantCurrent, local.FileName)
		}
		assert.Equal(t, wantCurrent, got.Current)
	}

	testCases := map[string]testCase{
		"no .bx anywhere": {
			start: "a/b",
		},
		"only in the start directory": {
			files:       []string{"a/b"},
			start:       "a/b",
			wantCurrent: "a/b",
		},
		"ancestors ordered outermost first": {
			files:       []string{"a", "a/b"},
			start:       "a/b/c",
			wantParents: []string{"a", "a/b"},
		},
		"current and parents": {
			files:       []string{"a", "a/b/c"},
			start:       "a/b/c",
			wantParents: []string{"a"},
			wantCurrent: "a/b/c",
		},
		"a .bx directory is skipped": {
			files:       []string{"a"},
			dirs:        []string{"a/b"},
			start:       "a/b/c",
			wantParents: []string{"a"},
		},
		"a .bx symlink to a file is used": {
			symlinks:    map[string]string{"a": "shared-bx"},
			start:       "a/b",
			wantParents: []string{"a"},
		},
	}

	for name, tc := range testCases {
		t.Run(name, func(t *testing.T) { run(t, tc) })
	}
}

func TestFilesSelect(t *testing.T) {
	type testCase struct {
		files       local.Files
		skipParents bool
		skipCurrent bool
		wantPaths   []string
		wantSkipped []string
	}

	run := func(t *testing.T, tc testCase) {
		// When
		paths, skipped := tc.files.Select(tc.skipParents, tc.skipCurrent)

		// Then
		assert.Equal(t, tc.wantPaths, paths)
		assert.Equal(t, tc.wantSkipped, skipped)
	}

	files := local.Files{Parents: []string{"/a/.bx", "/a/b/.bx"}, Current: "/a/b/c/.bx"}

	testCases := map[string]testCase{
		"nothing skipped": {
			files:     files,
			wantPaths: []string{"/a/.bx", "/a/b/.bx", "/a/b/c/.bx"},
		},
		"parents skipped": {
			files:       files,
			skipParents: true,
			wantPaths:   []string{"/a/b/c/.bx"},
			wantSkipped: []string{"/a/.bx", "/a/b/.bx"},
		},
		"current skipped": {
			files:       files,
			skipCurrent: true,
			wantPaths:   []string{"/a/.bx", "/a/b/.bx"},
			wantSkipped: []string{"/a/b/c/.bx"},
		},
		"all skipped": {
			files:       files,
			skipParents: true,
			skipCurrent: true,
			wantSkipped: []string{"/a/.bx", "/a/b/.bx", "/a/b/c/.bx"},
		},
		"no current file": {
			files:       local.Files{Parents: []string{"/a/.bx"}},
			skipCurrent: true,
			wantPaths:   []string{"/a/.bx"},
		},
		"empty files": {},
	}

	for name, tc := range testCases {
		t.Run(name, func(t *testing.T) { run(t, tc) })
	}
}
