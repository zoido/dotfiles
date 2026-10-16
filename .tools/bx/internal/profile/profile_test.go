package profile_test

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"bx/internal/profile"
)

func TestLoaderResolve(t *testing.T) {
	type testCase struct {
		files    map[string]string
		explicit string
		command  string
		want     []string
		wantErr  string
	}

	run := func(t *testing.T, tc testCase) {
		// Given
		loader := newLoader(t, tc.files)

		// When
		got, err := loader.Resolve(tc.explicit, tc.command)

		// Then
		if tc.wantErr != "" {
			require.ErrorContains(t, err, tc.wantErr)
			return
		}
		require.NoError(t, err)
		assert.Equal(t, tc.want, got)
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
		"explicit profile wins over command": {
			files: map[string]string{
				"npm":  "--share-net\n",
				"node": "--unshare-net\n",
			},
			explicit: "node",
			command:  "npm",
			want:     []string{"--unshare-net"},
		},
		"base is not loaded twice": {
			files:   map[string]string{"base": "--unshare-all\n"},
			command: "base",
			want:    []string{"--unshare-all"},
		},
		"missing explicit profile": {
			explicit: "nope",
			command:  "ls",
			wantErr:  `profile "nope"`,
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

func newLoader(t *testing.T, files map[string]string) profile.Loader {
	t.Helper()
	dir := t.TempDir()
	for name, content := range files {
		if err := os.WriteFile(filepath.Join(dir, name), []byte(content), 0o600); err != nil {
			t.Fatal(err)
		}
	}
	return profile.Loader{Dir: dir, Getenv: func(string) string { return "" }}
}
