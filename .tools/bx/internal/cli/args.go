// Package cli parses the bx command line.
package cli

import (
	"errors"
	"strings"
)

// Invocation is a parsed bx command line.
type Invocation struct {
	// Enable holds the profile names given as +name, in command-line order.
	Enable []string
	// Disable holds the profile names given as -name, in command-line order.
	Disable []string
	// BwrapArgs are extra arguments passed to bwrap unchanged.
	BwrapArgs []string
	// Command is the command and its arguments, or empty to start a shell.
	Command []string
}

// ErrEmptyToggle is returned when a toggle argument is a bare "+" or "-".
var ErrEmptyToggle = errors.New(`empty profile name after "+" or "-"`)

// Parse splits args into profile toggles, extra bwrap arguments and the
// command.
//
// The accepted forms are:
//
//	[+name | -name ...] command [args...]
//	[+name | -name ...] [bwrap args...] [-- command [args...]]
func Parse(args []string) (Invocation, error) {
	var inv Invocation

	for len(args) > 0 {
		arg := args[0]
		switch {
		case arg == "+" || arg == "-":
			return Invocation{}, ErrEmptyToggle
		case strings.HasPrefix(arg, "+"):
			inv.Enable = append(inv.Enable, strings.TrimPrefix(arg, "+"))
		case strings.HasPrefix(arg, "--"):
			bwrapArgs, command, _ := cutArgs(args, "--")
			inv.BwrapArgs = bwrapArgs
			inv.Command = command
			return inv, nil
		case strings.HasPrefix(arg, "-"):
			inv.Disable = append(inv.Disable, strings.TrimPrefix(arg, "-"))
		default:
			inv.Command = args
			return inv, nil
		}
		args = args[1:]
	}
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
