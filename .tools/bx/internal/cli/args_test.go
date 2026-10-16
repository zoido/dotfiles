package cli_test

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"bx/internal/cli"
)

func TestParse(t *testing.T) {
	type testCase struct {
		args    []string
		want    cli.Invocation
		wantErr error
	}

	run := func(t *testing.T, tc testCase) {
		// Given
		args := tc.args

		// When
		got, err := cli.Parse(args)

		// Then
		require.ErrorIs(t, err, tc.wantErr)
		assert.Equal(t, tc.want, got)
	}

	testCases := map[string]testCase{
		"no arguments": {
			args: nil,
			want: cli.Invocation{},
		},
		"command only": {
			args: []string{"npm", "i", "--save"},
			want: cli.Invocation{Command: []string{"npm", "i", "--save"}},
		},
		"command keeps separator": {
			args: []string{"git", "log", "--", "file"},
			want: cli.Invocation{Command: []string{"git", "log", "--", "file"}},
		},
		"profile and command": {
			args: []string{"@node", "npx", "foo"},
			want: cli.Invocation{Profile: "node", Command: []string{"npx", "foo"}},
		},
		"profile only": {
			args: []string{"@node"},
			want: cli.Invocation{Profile: "node", Command: []string{}},
		},
		"bwrap flags and command": {
			args: []string{"--bind", "a", "b", "--", "python", "t.py", "-v"},
			want: cli.Invocation{
				BwrapArgs: []string{"--bind", "a", "b"},
				Command:   []string{"python", "t.py", "-v"},
			},
		},
		"bwrap flags without command": {
			args: []string{"--share-net"},
			want: cli.Invocation{BwrapArgs: []string{"--share-net"}},
		},
		"bwrap flags with empty command": {
			args: []string{"--share-net", "--"},
			want: cli.Invocation{BwrapArgs: []string{"--share-net"}, Command: []string{}},
		},
		"separator only": {
			args: []string{"--", "-weird"},
			want: cli.Invocation{BwrapArgs: []string{}, Command: []string{"-weird"}},
		},
		"profile, bwrap flags and command": {
			args: []string{"@node", "--unshare-net", "--", "npm", "test"},
			want: cli.Invocation{
				Profile:   "node",
				BwrapArgs: []string{"--unshare-net"},
				Command:   []string{"npm", "test"},
			},
		},
		"empty profile": {
			args:    []string{"@", "ls"},
			wantErr: cli.ErrEmptyProfile,
		},
	}

	for name, tc := range testCases {
		t.Run(name, func(t *testing.T) { run(t, tc) })
	}
}
