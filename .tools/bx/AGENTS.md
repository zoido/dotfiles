# bx

bx is a small wrapper for [bubblewrap](https://github.com/containers/bubblewrap) (`bwrap`).
It builds a sandbox from profile files and runs a command inside it.
bx runs on Linux only.

## Usage

```
bx [+name | -name ...] command [args...]
bx [+name | -name ...] [bwrap flags...] [-- command [args...]]
```

- `+name` enables a profile for this run; several can be given in order.
- `-name` disables a profile everywhere it would load, including nested
  includes. Naming a profile with no file in `~/.bx/` is an error.
- Four profiles load automatically when they exist: `base`, the profile named
  after the command, the parent directories' `.bx` files (name `..`), and the
  working directory's `.bx` file (name `.`). `-.` and `-..` leave the local
  files out and are never errors.
- If the first argument after the toggles starts with `--`, every argument up
  to `--` goes to bwrap unchanged.
- If no command is given, bx starts `$SHELL`, or `/bin/sh` if `$SHELL` is not set.
- If `BX_DEBUG=1` is set, bx prints skipped profiles and the bwrap command to
  stderr before it runs.

## Profiles

Profiles are files in `~/.bx/`.
bx passes arguments to bwrap in this order:

1. `base`, if the file exists.
2. The profile named after the command's base name, if that file exists.
3. Each `+name` profile, in command-line order. Each profile loads once.
4. Local `.bx` files from parent directories, outermost first (name `..`).
5. `./.bx`, the working directory's local file (name `.`).
6. Extra bwrap flags from the command line.
7. `--`, then the command and its arguments.

In bwrap, later flags override earlier ones. For example, `--unshare-net` after `--share-net` turns the network off.

The profile file format:

- Each line holds one bwrap flag and its values.
- Lines are split with `github.com/google/shlex`, so quotes work. Text after `#` is a comment.
- After splitting, bx expands `$VAR` and `${VAR}` in each word. `$PWD` always holds the real working directory.
- `include <name>` inserts another profile at that line. Includes can be nested. An include cycle is an error.

Local `.bx` files are parsed the same way, with two extras that do not apply
to profiles they include: `$BX_DIR` holds the file's directory, and a word
that starts with `./` or `../` resolves against the file's directory.

## Layout

- `main.go` is the entry point. It resolves the shell and the environment, and runs bwrap with `syscall.Exec`.
- `internal/cli` parses the command line.
- `internal/local` discovers `.bx` files in the working directory and its parents.
- `internal/profile` loads profiles, follows includes, expands variables, and selects the profile.

Keep each package focused on one job. `main.go` connects the packages and must not hold logic.

## Plans

Feature plans live in `plan-<feature>.md` files and are listed in `PLANS.md`.
When you add a plan, name the file after the feature and add a link with a
one-line summary to `PLANS.md`.

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
