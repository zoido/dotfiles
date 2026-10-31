# Unified plan: profile toggles, local profiles, special names

Status: implemented.

One implementation plan for the three planned features — profile toggles,
local `.bx` profiles, and special profile names — in dependency order.

Target behavior after all phases:

```
bx [+name | -name ...] command [args...]
bx [+name | -name ...] [bwrap flags...] [-- command [args...]]
```

Load order (later bwrap flags win):

1. `base` (`~/.bx/base`), if it exists.
2. The command profile (`~/.bx/<command base name>`), if it exists.
3. Each `+name` profile, in command-line order, each top-level name once.
4. Local `.bx` files from parent directories, outermost first (name `..`).
5. `./.bx` (name `.`).
6. Extra bwrap flags from the command line.
7. `--`, then the command.

`-name` disables a profile everywhere it would load, including nested
includes. `+x -x` loads nothing of `x`. `-typo` for a name with no file in
`~/.bx/` is an error; `-.` and `-..` are never errors. `@name` is removed.

## Phase 1: Profile toggles (`+name` / `-name`)

### Step 1.1: `internal/cli`

- In `Invocation`, replace `Profile string` with `Enable []string` and
  `Disable []string`. Keep `BwrapArgs` and `Command`.
- In `Parse`, loop over leading arguments:
  - `+name` appends to `Enable`.
  - `-name` (single dash) appends to `Disable`.
  - `--...` ends the loop and starts the bwrap-flags form (cut at `--` as
    today).
  - Anything else ends the loop and starts the command form.
- Bare `+` or `-` is an error. Keep the error variable exported for
  `main.go`'s usage printing; rename `ErrEmptyProfile` if the wording no
  longer fits.
- Remove `@name` handling.

Tests (table-driven, black-box, Given-When-Then):

- single `+name` with command; several `+name` keep order.
- `-name` alone; mixed `+a -b +c`.
- toggles followed by bwrap flags and `--` command.
- bare `+` and bare `-`: error.
- command arguments with `-x`/`+x` are untouched (`bx ls -la`).
- no arguments at all.

### Step 1.2: `internal/profile`

- `Loader` gets a disabled set (`map[string]bool` or `[]string`).
- `load(name, chain)` returns `(nil, nil)` when the name is disabled; this
  covers includes at any depth. Record each skip.
- `Resolve(enable []string, command string)`:
  1. Verify every disabled name exists; a missing one is
     `unknown profile "typo"`.
  2. Build the ordered list: `base`, the command profile when its file
     exists, then `enable` in order. Drop duplicates (first occurrence
     wins) and disabled names.
  3. Load each name and concatenate.
- Skip reporting for `BX_DEBUG`: prefer the smallest change — a
  `Skipped []string` field appended by `load` (pointer receiver) or a small
  result struct from `Resolve`.

Tests:

- enable order preserved; base and command profile first.
- duplicate enable names load once; `+cmd` equal to the command profile
  loads once.
- disabled base; disabled command profile; `+x -x` loads nothing of `x`.
- disabled profile in a nested include is skipped and the rest of the
  including profile still loads.
- disabling or enabling a name with no profile file: error.

### Step 1.3: `main.go` and docs

- Pass `inv.Disable` into the `Loader` and `inv.Enable` into `Resolve`.
- Update `usage` to the new forms.
- With `BX_DEBUG=1`, print skipped profiles before the bwrap command.
- `README.md`: update usage and examples (`@node` → `+node`, add a `-net`
  example); add a "Counter-profiles" section (use `+` counter-profiles for
  flags bwrap can undo, `-name` for flags it cannot).
- `AGENTS.md`: update Usage and Profiles to the new syntax.

### Step 1.4: Verify phase 1

```
go test ./...
go vet ./...
golangci-lint run ./...
gofumpt -l .
```

Manual smoke test with `BX_DEBUG=1` and a scratch `~/.bx`:
`bx +net -base -- ls`, `bx -npm npm i`, `bx +a +b -- true`.

## Phase 2: Local `.bx` profiles

### Step 2.1: `internal/local` (new package, discovery only)

- `Find(dir string) (Files, error)` walks from `/` down to `dir` and
  returns:

  ```go
  type Files struct {
      Parents []string // Outermost first.
      Current string   // Empty when dir has no .bx file.
  }
  ```

  (This is the shape phase 3 needs; build it here directly instead of a
  flat list.)
- Use `.bx` only when it is a regular file or a symlink to one; skip
  directories (`~/.bx` is a directory on the walk through `$HOME`).
- A `.bx` that exists but cannot be read is an error.
- `Find` takes the start directory; it does not call `os.Getwd`.

Tests:

- no `.bx` anywhere: empty result.
- `.bx` only in the start directory: `Current` set, `Parents` empty.
- `.bx` in several ancestors: `Parents` ordered outermost first.
- both current and parents: each field correct.
- a `.bx` directory in the path is skipped.
- a `.bx` symlink to a file is used.
- The walk reaches `/`, so assert only on paths under `t.TempDir()` (or
  give `Find` a test-only stop directory; prefer the assertion filter).

### Step 2.2: `internal/profile` — `LoadFile`

- Split parsing so it works on a path and a display name:
  - `load(name, chain)` resolves `l.path(name)` and calls the shared
    parser.
  - `LoadFile(path string) ([]string, error)` parses a local file. Its
    `Getenv` adds `BX_DIR = filepath.Dir(path)`. Includes go through `load`
    with the plain loader `Getenv`, so `$BX_DIR` does not leak into
    `~/.bx/` profiles.
  - The include chain for a local file starts with its path, so a cycle
    reads `/a/.bx -> node -> ...`.
- Relative paths resolve against the profile file: after env expansion,
  a word that starts with `./` or `../` becomes
  `filepath.Join(filepath.Dir(path), word)`. So `--bind ./cache /x` in
  `/a/b/.bx` binds `/a/b/cache` no matter where bx runs. The explicit
  prefix rule keeps non-path values (`--setenv FOO bar`, `--perms 0755`)
  untouched; it is sugar for `$BX_DIR/...`. This applies only to local
  `.bx` files (current and parents), not to `~/.bx/` profiles and not to
  profiles they include — consistent with `$BX_DIR` not leaking into
  includes.
- Error messages use the file path: `/a/b/.bx:3: ...`.

Tests:

- flags parsed like a profile.
- `$BX_DIR` expands to the file's directory.
- `./cache` and `../shared` resolve against the file's directory; a bare
  word (`cache`) and flag words (`--setenv`, `0755`) stay untouched.
- relative paths in an included `~/.bx/` profile are not resolved.
- `include name` loads from the loader's `Dir`.
- `$BX_DIR` inside an included `~/.bx/` profile is not the local directory.
- a parse error reports the file path and line.
- an include cycle starting from a local file is reported.

### Step 2.3: `main.go` and docs

- Reuse the working directory already fetched for `$PWD`; pass it to
  `local.Find`.
- `loader.LoadFile(path)` for each parent path, then the current path;
  append after `Resolve`'s result and before `inv.BwrapArgs`.
- With `BX_DEBUG=1`, print `bx: local profile <path>` for each file.
- Update `usage` with one line about `.bx` files.
- `README.md`: "Local profiles" section with load order, `$BX_DIR`, the
  `./`-relative path rule, an example, and the trust warning (no trust check; a `.bx` in a cloned repo
  can weaken or remove the sandbox, check `.bx` files first).
- `AGENTS.md`: add the local step to the Profiles order and
  `internal/local` to Layout.

### Step 2.4: Verify phase 2

Same commands as step 1.4, plus a manual run in a directory tree with
`.bx` files and `BX_DEBUG=1`.

## Phase 3: Special names `.` and `..`

### Step 3.1: `internal/profile`

- Export `CurrentDirName = "."` and `ParentDirName = ".."`.
- `Resolve` skips `.` and `..` in the disabled-names existence check and
  ignores them in the enable list (`+.`/`+..` do nothing; the local files
  load anyway).
- `load` errors on `include .` and `include ..`:
  `"." and ".." name local files and cannot be included`.

Tests:

- `-.` and `-..` with no local files: no error.
- `+.` and `+..`: no error and no extra arguments.
- `include .` and `include ..`: error.
- `-npm` with the command `npm`: the command profile is not loaded.

### Step 3.2: `internal/cli` tests only

No code change: `.` and `..` pass through `Enable`/`Disable` like any name.
Add tests:

- `-.`, `-..`, `+.`, `+..` are toggles, not the command.
- `-. ls -la` gives the command `ls -la`.

### Step 3.3: `main.go` and docs

- Leave out `Files.Parents` when `inv.Disable` contains `..`, and
  `Files.Current` when it contains `.`.
- With `BX_DEBUG=1`, print `bx: skipped local profile <path>` for each
  file that is left out.
- If the filtering grows beyond two conditions, move it into
  `internal/local` as `Files.Select(disable []string) []string` and test it
  there.
- Update `usage` with the `.` and `..` names.
- `README.md`: show `-.` and `-..` in the local profiles section, with
  `-npm` named next to them.
- `AGENTS.md`: list the four automatic profiles and their names
  (`base`, command name, `.`, `..`).

### Step 3.4: Verify phase 3

Same commands as step 1.4. Manual smoke test with `BX_DEBUG=1`, a scratch
`~/.bx`, and `.bx` files in a temporary directory and its parent:
`bx -. -- true`, `bx -.. -- true`, `bx -. -.. -- true`, `bx +. -- true`.

## Commit plan

One branch per phase, stacked with git-spice
(`z/profiles=toggles`, `z/profiles=local`, `z/profiles=special-names`),
each phase green on its own.
