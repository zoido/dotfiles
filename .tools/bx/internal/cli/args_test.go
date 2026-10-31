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
		"enable and command": {
			args: []string{"+node", "npx", "foo"},
			want: cli.Invocation{Enable: []string{"node"}, Command: []string{"npx", "foo"}},
		},
		"enable only": {
			args: []string{"+node"},
			want: cli.Invocation{Enable: []string{"node"}},
		},
		"several enables keep order": {
			args: []string{"+a", "+b", "+c", "ls"},
			want: cli.Invocation{Enable: []string{"a", "b", "c"}, Command: []string{"ls"}},
		},
		"disable only": {
			args: []string{"-net"},
			want: cli.Invocation{Disable: []string{"net"}},
		},
		"mixed toggles": {
			args: []string{"+a", "-b", "+c", "make"},
			want: cli.Invocation{
				Enable:  []string{"a", "c"},
				Disable: []string{"b"},
				Command: []string{"make"},
			},
		},
		"toggles, bwrap flags and command": {
			args: []string{"+node", "--unshare-net", "--", "npm", "test"},
			want: cli.Invocation{
				Enable:    []string{"node"},
				BwrapArgs: []string{"--unshare-net"},
				Command:   []string{"npm", "test"},
			},
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
		"command arguments are untouched": {
			args: []string{"ls", "-la", "+x"},
			want: cli.Invocation{Command: []string{"ls", "-la", "+x"}},
		},
		"special names are toggles": {
			args: []string{"-.", "-..", "+.", "+.."},
			want: cli.Invocation{
				Enable:  []string{".", ".."},
				Disable: []string{".", ".."},
			},
		},
		"special name before command": {
			args: []string{"-.", "ls", "-la"},
			want: cli.Invocation{Disable: []string{"."}, Command: []string{"ls", "-la"}},
		},
		"bare plus": {
			args:    []string{"+", "ls"},
			wantErr: cli.ErrEmptyToggle,
		},
		"bare dash": {
			args:    []string{"-", "ls"},
			wantErr: cli.ErrEmptyToggle,
		},
	}

	for name, tc := range testCases {
		t.Run(name, func(t *testing.T) { run(t, tc) })
	}
}
