// Package cli parses the bx command line.
package cli

import (
	"errors"
	"strings"
)

// Invocation is a parsed bx command line.
type Invocation struct {
	// Profile is the profile named with @name, or empty when none was given.
	Profile string
	// BwrapArgs are extra arguments passed to bwrap unchanged.
	BwrapArgs []string
	// Command is the command and its arguments, or empty to start a shell.
	Command []string
}

// ErrEmptyProfile is returned when the profile argument is a bare "@".
var ErrEmptyProfile = errors.New("empty profile name after @")

// Parse splits args into the profile, extra bwrap arguments and the command.
//
// The accepted forms are:
//
//	[@profile] command [args...]
//	[@profile] [bwrap args...] [-- command [args...]]
func Parse(args []string) (Invocation, error) {
	var inv Invocation

	if len(args) > 0 && strings.HasPrefix(args[0], "@") {
		inv.Profile = strings.TrimPrefix(args[0], "@")
		if inv.Profile == "" {
			return Invocation{}, ErrEmptyProfile
		}
		args = args[1:]
	}

	if len(args) == 0 || !strings.HasPrefix(args[0], "-") {
		inv.Command = args
		return inv, nil
	}

	bwrapArgs, command, _ := cutArgs(args, "--")
	inv.BwrapArgs = bwrapArgs
	inv.Command = command
	return inv, nil
}

func cutArgs(args []string, sep string) (before, after []string, found bool) {
	for i, arg := range args {
		if arg == sep {
			return args[:i], args[i+1:], true
		}
	}
	return args, nil, false
}
