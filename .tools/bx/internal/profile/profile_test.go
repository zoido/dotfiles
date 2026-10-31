package profile_test

import (
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"bx/internal/profile"
)

func TestLoaderResolve(t *testing.T) {
	type testCase struct {
		files       map[string]string
		enable      []string
		disable     []string
		command     string
		want        []string
		wantSkipped []string
		wantErr     string
	}

	run := func(t *testing.T, tc testCase) {
		// Given
		loader := newLoader(t, tc.files)
		loader.Disable = tc.disable

		// When
		got, err := loader.Resolve(tc.enable, tc.command)

		// Then
		if tc.wantErr != "" {
			require.ErrorContains(t, err, tc.wantErr)
			return
		}
		require.NoError(t, err)
		assert.Equal(t, tc.want, got)
		assert.Equal(t, tc.wantSkipped, loader.Skipped)
	}

	testCases := map[string]testCase{
		"no profiles": {
			command: "ls",
			want:    nil,
		},
		"base only": {
			files:   map[string]string{"base": "--unshare-all\n"},
			command: "ls",
			want:    []string{"--unshare-all"},
		},
		"base and command profile": {
			files: map[string]string{
				"base": "--unshare-all\n",
				"npm":  "--share-net\n",
			},
			command: "npm",
			want:    []string{"--unshare-all", "--share-net"},
		},
		"command profile from path": {
			files:   map[string]string{"npm": "--share-net\n"},
			command: "/usr/bin/npm",
			want:    []string{"--share-net"},
		},
		"enable order preserved after base and command profile": {
			files: map[string]string{
				"base": "--base\n",
				"npm":  "--npm\n",
				"a":    "--a\n",
				"b":    "--b\n",
			},
			enable:  []string{"b", "a"},
			command: "npm",
			want:    []string{"--base", "--npm", "--b", "--a"},
		},
		"duplicate enable names load once": {
			files:   map[string]string{"a": "--a\n"},
			enable:  []string{"a", "a"},
			command: "ls",
			want:    []string{"--a"},
		},
		"enable equal to command profile loads once": {
			files:   map[string]string{"npm": "--npm\n"},
			enable:  []string{"npm"},
			command: "npm",
			want:    []string{"--npm"},
		},
		"base is not loaded twice": {
			files:   map[string]string{"base": "--unshare-all\n"},
			command: "base",
			want:    []string{"--unshare-all"},
		},
		"disabled base": {
			files: map[string]string{
				"base": "--base\n",
				"npm":  "--npm\n",
			},
			disable:     []string{"base"},
			command:     "npm",
			want:        []string{"--npm"},
			wantSkipped: []string{"base"},
		},
		"disabled command profile": {
			files: map[string]string{
				"base": "--base\n",
				"npm":  "--npm\n",
			},
			disable:     []string{"npm"},
			command:     "npm",
			want:        []string{"--base"},
			wantSkipped: []string{"npm"},
		},
		"enable and disable load nothing": {
			files:       map[string]string{"x": "--x\n"},
			enable:      []string{"x"},
			disable:     []string{"x"},
			command:     "ls",
			want:        nil,
			wantSkipped: []string{"x"},
		},
		"disabled nested include is skipped": {
			files: map[string]string{
				"a":   "--first\ninclude b\n--last\n",
				"b":   "include net\n--b\n",
				"net": "--share-net\n",
			},
			enable:      []string{"a"},
			disable:     []string{"net"},
			command:     "ls",
			want:        []string{"--first", "--b", "--last"},
			wantSkipped: []string{"net"},
		},
		"missing enabled profile": {
			enable:  []string{"nope"},
			command: "ls",
			wantErr: `profile "nope"`,
		},
		"missing disabled profile": {
			disable: []string{"typo"},
			command: "ls",
			wantErr: `unknown profile "typo"`,
		},
		"disabled special names are never errors": {
			disable: []string{".", ".."},
			command: "ls",
			want:    nil,
		},
		"enabled special names are ignored": {
			files:   map[string]string{"base": "--base\n"},
			enable:  []string{".", ".."},
			command: "ls",
			want:    []string{"--base"},
		},
		"disabled command profile by command name": {
			files:       map[string]string{"npm": "--npm\n"},
			disable:     []string{"npm"},
			command:     "npm",
			want:        nil,
			wantSkipped: []string{"npm"},
		},
	}

	for name, tc := range testCases {
		t.Run(name, func(t *testing.T) { run(t, tc) })
	}
}

func TestLoaderLoad(t *testing.T) {
	type testCase struct {
		files   map[string]string
		name    string
		env     map[string]string
		want    []string
		wantErr string
	}

	run := func(t *testing.T, tc testCase) {
		// Given
		loader := newLoader(t, tc.files)
		loader.Getenv = func(key string) string { return tc.env[key] }

		// When
		got, err := loader.Load(tc.name)

		// Then
		if tc.wantErr != "" {
			require.ErrorContains(t, err, tc.wantErr)
			return
		}
		require.NoError(t, err)
		assert.Equal(t, tc.want, got)
	}

	testCases := map[string]testCase{
		"flags with values": {
			files: map[string]string{"p": "--ro-bind /usr /usr\n--share-net\n"},
			name:  "p",
			want:  []string{"--ro-bind", "/usr", "/usr", "--share-net"},
		},
		"comments and blank lines": {
			files: map[string]string{"p": "# comment\n\n  --share-net # trailing\n"},
			name:  "p",
			want:  []string{"--share-net"},
		},
		"no trailing newline": {
			files: map[string]string{"p": "--share-net"},
			name:  "p",
			want:  []string{"--share-net"},
		},
		"quoted value": {
			files: map[string]string{"p": `--bind "/a b" '/c d'` + "\n"},
			name:  "p",
			want:  []string{"--bind", "/a b", "/c d"},
		},
		"variables": {
			files: map[string]string{"p": "--bind $HOME/x ${HOME}/x\n"},
			name:  "p",
			env:   map[string]string{"HOME": "/home/u"},
			want:  []string{"--bind", "/home/u/x", "/home/u/x"},
		},
		"variable with spaces stays one word": {
			files: map[string]string{"p": "--chdir $PWD\n"},
			name:  "p",
			env:   map[string]string{"PWD": "/a b"},
			want:  []string{"--chdir", "/a b"},
		},
		"include in place": {
			files: map[string]string{
				"p":   "--first\ninclude net\n--last\n",
				"net": "--share-net\n",
			},
			name: "p",
			want: []string{"--first", "--share-net", "--last"},
		},
		"nested include": {
			files: map[string]string{
				"a": "include b\n",
				"b": "include c\n",
				"c": "--c\n",
			},
			name: "a",
			want: []string{"--c"},
		},
		"repeated include": {
			files: map[string]string{
				"a":   "include b\ninclude c\n",
				"b":   "include net\n",
				"c":   "include net\n",
				"net": "--share-net\n",
			},
			name: "a",
			want: []string{"--share-net", "--share-net"},
		},
		"include cycle": {
			files: map[string]string{
				"a": "include b\n",
				"b": "include a\n",
			},
			name:    "a",
			wantErr: "include cycle: a -> b -> a",
		},
		"self include": {
			files:   map[string]string{"a": "include a\n"},
			name:    "a",
			wantErr: "include cycle: a -> a",
		},
		"missing include": {
			files:   map[string]string{"a": "include nope\n"},
			name:    "a",
			wantErr: `profile "nope"`,
		},
		"include without name": {
			files:   map[string]string{"a": "--x\ninclude\n"},
			name:    "a",
			wantErr: "a:2: include needs exactly one profile name",
		},
		"include current dir name": {
			files:   map[string]string{"a": "include .\n"},
			name:    "a",
			wantErr: `a:1: "." and ".." name local files and cannot be included`,
		},
		"include parent dir name": {
			files:   map[string]string{"a": "include ..\n"},
			name:    "a",
			wantErr: `a:1: "." and ".." name local files and cannot be included`,
		},
		"bad quoting": {
			files:   map[string]string{"a": "--bind \"/a\n"},
			name:    "a",
			wantErr: "a:1:",
		},
	}

	for name, tc := range testCases {
		t.Run(name, func(t *testing.T) { run(t, tc) })
	}
}

func TestLoaderLoadFile(t *testing.T) {
	type testCase struct {
		// profiles are files in the loader's Dir.
		profiles map[string]string
		// content is the content of the local .bx file.
		content string
		env     map[string]string
		// want may use {DIR} for the local directory and {PARENT} for its parent.
		want []string
		// wantErr may use {FILE} for the local file path.
		wantErr string
	}

	run := func(t *testing.T, tc testCase) {
		// Given
		loader := newLoader(t, tc.profiles)
		loader.Getenv = func(key string) string { return tc.env[key] }
		dir := t.TempDir()
		path := filepath.Join(dir, ".bx")
		if err := os.WriteFile(path, []byte(tc.content), 0o600); err != nil {
			t.Fatal(err)
		}

		// When
		got, err := loader.LoadFile(path)

		// Then
		if tc.wantErr != "" {
			require.ErrorContains(t, err, strings.ReplaceAll(tc.wantErr, "{FILE}", path))
			return
		}
		require.NoError(t, err)
		want := make([]string, len(tc.want))
		for i, word := range tc.want {
			word = strings.ReplaceAll(word, "{DIR}", dir)
			want[i] = strings.ReplaceAll(word, "{PARENT}", filepath.Dir(dir))
		}
		assert.Equal(t, want, got)
	}

	testCases := map[string]testCase{
		"flags parsed like a profile": {
			content: "# comment\n--ro-bind /usr /usr\n--share-net\n",
			want:    []string{"--ro-bind", "/usr", "/usr", "--share-net"},
		},
		"BX_DIR expands to the file directory": {
			content: "--bind $BX_DIR/cache /cache\n",
			want:    []string{"--bind", "{DIR}/cache", "/cache"},
		},
		"relative paths resolve against the file directory": {
			content: "--bind ./cache /x\n--ro-bind ../shared /y\n",
			want: []string{
				"--bind", "{DIR}/cache", "/x",
				"--ro-bind", "{PARENT}/shared", "/y",
			},
		},
		"bare words and flag words stay untouched": {
			content: "--setenv FOO bar\n--perms 0755 --tmpfs /t\n--chdir cache\n",
			want: []string{
				"--setenv", "FOO", "bar",
				"--perms", "0755", "--tmpfs", "/t",
				"--chdir", "cache",
			},
		},
		"include loads from the loader directory": {
			profiles: map[string]string{"net": "--share-net\n"},
			content:  "--first\ninclude net\n--last\n",
			want:     []string{"--first", "--share-net", "--last"},
		},
		"relative paths in an included profile are not resolved": {
			profiles: map[string]string{"p": "--bind ./cache /x\n"},
			content:  "include p\n",
			want:     []string{"--bind", "./cache", "/x"},
		},
		"BX_DIR in an included profile is not the local directory": {
			profiles: map[string]string{"p": "--bind $BX_DIR /x\n"},
			content:  "include p\n",
			want:     []string{"--bind", "", "/x"},
		},
		"parse error reports the file path and line": {
			content: "--share-net\n--bind \"/a\n",
			wantErr: "{FILE}:2:",
		},
		"include cycle starting from the local file": {
			profiles: map[string]string{
				"a": "include b\n",
				"b": "include a\n",
			},
			content: "include a\n",
			wantErr: "include cycle: {FILE} -> a -> b -> a",
		},
	}

	for name, tc := range testCases {
		t.Run(name, func(t *testing.T) { run(t, tc) })
	}
}

func TestLoaderLoadFiles(t *testing.T) {
	type testCase struct {
		// files maps a relative path to the content of a local .bx file.
		files map[string]string
		// paths are the relative paths to load, in order.
		paths   []string
		want    []string
		wantErr string
	}

	run := func(t *testing.T, tc testCase) {
		// Given
		loader := newLoader(t, nil)
		root := t.TempDir()
		for name, content := range tc.files {
			path := filepath.Join(root, name)
			if err := os.MkdirAll(filepath.Dir(path), 0o700); err != nil {
				t.Fatal(err)
			}
			if err := os.WriteFile(path, []byte(content), 0o600); err != nil {
				t.Fatal(err)
			}
		}
		paths := make([]string, len(tc.paths))
		for i, path := range tc.paths {
			paths[i] = filepath.Join(root, path)
		}

		// When
		got, err := loader.LoadFiles(paths)

		// Then
		if tc.wantErr != "" {
			require.ErrorContains(t, err, tc.wantErr)
			return
		}
		require.NoError(t, err)
		assert.Equal(t, tc.want, got)
	}

	testCases := map[string]testCase{
		"no paths": {},
		"arguments keep the path order": {
			files: map[string]string{
				"a/.bx":   "--a\n",
				"a/b/.bx": "--b\n",
			},
			paths: []string{"a/.bx", "a/b/.bx"},
			want:  []string{"--a", "--b"},
		},
		"missing file": {
			files:   map[string]string{"a/.bx": "--a\n"},
			paths:   []string{"a/.bx", "a/b/.bx"},
			wantErr: "local profile",
		},
	}

	for name, tc := range testCases {
		t.Run(name, func(t *testing.T) { run(t, tc) })
	}
}

func TestEnv(t *testing.T) {
	// Given
	t.Setenv("PWD", "/somewhere/else")
	t.Setenv("BX_TEST_VAR", "value")

	// When
	getenv := profile.Env("/real/wd")

	// Then
	assert.Equal(t, "/real/wd", getenv("PWD"))
	assert.Equal(t, "value", getenv("BX_TEST_VAR"))
	assert.Empty(t, getenv("BX_TEST_UNSET"))
}

func newLoader(t *testing.T, files map[string]string) *profile.Loader {
	t.Helper()
	dir := t.TempDir()
	for name, content := range files {
		if err := os.WriteFile(filepath.Join(dir, name), []byte(content), 0o600); err != nil {
			t.Fatal(err)
		}
	}
	return &profile.Loader{Dir: dir, Getenv: func(string) string { return "" }}
}
