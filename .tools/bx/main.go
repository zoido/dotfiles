// Command bx runs a command inside a bubblewrap sandbox built from profiles.
package main

import (
	"errors"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"syscall"

	"al.essio.dev/pkg/shellescape"

	"bx/internal/cli"
	"bx/internal/profile"
)

const usage = `usage:
  bx [@profile] command [args...]
  bx [@profile] [bwrap flags...] [-- command [args...]]

Profiles live in ~/.bx. The profile "base" is always loaded first. Then the
profile @profile is loaded, or the profile named after the command if it
exists. Without a command, bx starts $SHELL.

For flags like --share-net and --unshare-net the last one wins, so a profile
or the command line can override base.

Set BX_DEBUG=1 to print the bwrap command before it runs.`

const defaultShell = "/bin/sh"

func main() {
	err := run(os.Args[1:])
	if errors.Is(err, cli.ErrEmptyProfile) {
		fmt.Fprintf(os.Stderr, "bx: %v\n\n%s\n", err, usage)
		os.Exit(2)
	}
	if err != nil {
		fmt.Fprintf(os.Stderr, "bx: %v\n", err)
		os.Exit(1)
	}
}

func run(args []string) error {
	inv, err := cli.Parse(args)
	if err != nil {
		return err
	}
	if len(inv.Command) == 0 {
		inv.Command = []string{shell()}
	}

	home, err := os.UserHomeDir()
	if err != nil {
		return err
	}
	getenv, err := profileEnv()
	if err != nil {
		return err
	}
	loader := profile.Loader{Dir: filepath.Join(home, ".bx"), Getenv: getenv}

	profileArgs, err := loader.Resolve(inv.Profile, inv.Command[0])
	if err != nil {
		return err
	}

	bwrap, err := exec.LookPath("bwrap")
	if err != nil {
		return err
	}

	argv := []string{"bwrap"}
	argv = append(argv, profileArgs...)
	argv = append(argv, inv.BwrapArgs...)
	argv = append(argv, "--")
	argv = append(argv, inv.Command...)

	if os.Getenv("BX_DEBUG") != "" {
		fmt.Fprintln(os.Stderr, shellescape.QuoteCommand(argv))
	}

	if err := syscall.Exec(bwrap, argv, os.Environ()); err != nil {
		return fmt.Errorf("exec bwrap: %w", err)
	}
	return nil
}

func shell() string {
	if sh := os.Getenv("SHELL"); sh != "" {
		return sh
	}
	return defaultShell
}

// profileEnv returns the environment lookup for profiles. PWD always holds
// the real working directory, even when the caller did not set it.
func profileEnv() (func(string) string, error) {
	wd, err := os.Getwd()
	if err != nil {
		return nil, err
	}
	return func(key string) string {
		if key == "PWD" {
			return wd
		}
		return os.Getenv(key)
	}, nil
}
