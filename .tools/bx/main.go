// Command bx runs a command inside a bubblewrap sandbox built from profiles.
package main

import (
	"errors"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"slices"
	"syscall"

	"al.essio.dev/pkg/shellescape"

	"bx/internal/cli"
	"bx/internal/local"
	"bx/internal/profile"
)

const usage = `usage:
  bx [+name | -name ...] command [args...]
  bx [+name | -name ...] [bwrap flags...] [-- command [args...]]

Profiles live in ~/.bx. The profile "base" is loaded first, then the profile
named after the command if it exists, then each +name profile in order, then
.bx files from parent directories and the working directory.
-name disables a profile everywhere it would load, including includes.
The names "." and ".." stand for the working directory's .bx file and the
parent directories' .bx files; -. and -.. leave them out.
Without a command, bx starts $SHELL.

For flags like --share-net and --unshare-net the last one wins, so a later
profile or the command line can override an earlier one.

Set BX_DEBUG=1 to print the bwrap command before it runs.`

const defaultShell = "/bin/sh"

func main() {
	err := run(os.Args[1:])
	if errors.Is(err, cli.ErrEmptyToggle) {
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
	wd, err := os.Getwd()
	if err != nil {
		return err
	}
	loader := &profile.Loader{Dir: filepath.Join(home, ".bx"), Getenv: profile.Env(wd), Disable: inv.Disable}

	profileArgs, err := loader.Resolve(inv.Enable, inv.Command[0])
	if err != nil {
		return err
	}

	localFiles, err := local.Find(wd)
	if err != nil {
		return err
	}
	localPaths, skippedLocal := localFiles.Select(
		slices.Contains(inv.Disable, profile.ParentDirName),
		slices.Contains(inv.Disable, profile.CurrentDirName),
	)
	localArgs, err := loader.LoadFiles(localPaths)
	if err != nil {
		return err
	}

	bwrap, err := exec.LookPath("bwrap")
	if err != nil {
		return err
	}

	argv := []string{"bwrap"}
	argv = append(argv, profileArgs...)
	argv = append(argv, localArgs...)
	argv = append(argv, inv.BwrapArgs...)
	argv = append(argv, "--")
	argv = append(argv, inv.Command...)

	if os.Getenv("BX_DEBUG") != "" {
		for _, name := range loader.Skipped {
			fmt.Fprintf(os.Stderr, "bx: skipped profile %s\n", name)
		}
		for _, path := range skippedLocal {
			fmt.Fprintf(os.Stderr, "bx: skipped local profile %s\n", path)
		}
		for _, path := range localPaths {
			fmt.Fprintf(os.Stderr, "bx: local profile %s\n", path)
		}
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
