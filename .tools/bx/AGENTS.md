# bx

bx is a small wrapper for [bubblewrap](https://github.com/containers/bubblewrap) (`bwrap`).
It builds a sandbox from profile files and runs a command inside it.
bx runs on Linux only.

## Usage

```
bx [@profile] command [args...]
bx [@profile] [bwrap flags...] [-- command [args...]]
```

- `@profile` selects a profile by name.
- If the first argument (after `@profile`) starts with `-`, every argument up to `--` goes to bwrap unchanged.
- If no command is given, bx starts `$SHELL`, or `/bin/sh` if `$SHELL` is not set.
- If `BX_DEBUG=1` is set, bx prints the bwrap command to stderr before it runs.

## Profiles

Profiles are files in `~/.bx/`.
bx passes arguments to bwrap in this order:

1. `base`, if the file exists.
2. The profile from `@profile`, or else the profile named after the command's base name, if that file exists.
3. Extra bwrap flags from the command line.
4. `--`, then the command and its arguments.

In bwrap, later flags override earlier ones. For example, `--unshare-net` after `--share-net` turns the network off.

The profile file format:

- Each line holds one bwrap flag and its values.
- Lines are split with `github.com/google/shlex`, so quotes work. Text after `#` is a comment.
- After splitting, bx expands `$VAR` and `${VAR}` in each word. `$PWD` always holds the real working directory.
- `include <name>` inserts another profile at that line. Includes can be nested. An include cycle is an error.

## Layout

- `main.go` is the entry point. It resolves the shell and the environment, and runs bwrap with `syscall.Exec`.
- `internal/cli` parses the command line.
- `internal/profile` loads profiles, follows includes, expands variables, and selects the profile.

Keep each package focused on one job. `main.go` connects the packages and must not hold logic.

## Development

```
go test ./...
go vet ./...
golangci-lint run ./...
gofumpt -l .
```

- Use the Go version in `go.mod` and its language features.
- Write black-box tests (`package x_test`) as table-driven tests with testify, in the Given-When-Then structure.
- Add a dependency only if it replaces code that is not trivial.
