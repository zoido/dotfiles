<div align="center">

# 📦 bx

**Sandbox any command with [bubblewrap](https://github.com/containers/bubblewrap), using plain-text profiles.**

![Go](https://img.shields.io/badge/go-1.27-00ADD8?logo=go&logoColor=white)
![Platform](https://img.shields.io/badge/platform-linux-FCC624?logo=linux&logoColor=black)

</div>

```console
$ bx npm install           # Runs npm with the base and npm profiles.
$ bx +pi                   # Opens a shell with the pi profile.
$ bx -net cloc .           # Runs cloc without the net profile.
$ bx --unshare-net -- make # Adds a bwrap flag for one run.
```

## ✨ Features

- **Profiles:** one bwrap flag per line, in a plain-text file.
- **Automatic selection:** `bx npm` loads `~/.bx/npm` if that file exists.
- **Toggles:** `+name` adds a profile for one run, `-name` keeps one out everywhere, even from includes.
- **Local profiles:** a `.bx` file in the working directory or any parent adds flags for that tree.
- **Includes:** combine profiles with `include <name>`. bx stops with an error if includes loop.
- **Variables:** `$HOME`, `$PWD` and any other environment variable.
- **Direct bwrap flags:** pass any bwrap flag on the command line.
- **No extra process:** bx replaces itself with bwrap, so signals and exit codes pass straight through.

## 🚀 Install

You need Linux and `bwrap` on your `PATH`.

```sh
git clone <repo-url> bx
go install -C bx .
```

## 🧭 Usage

```
bx [+name | -name ...] command [args...]
bx [+name | -name ...] [bwrap flags...] [-- command [args...]]
```

| You type | Profiles | Extra bwrap flags | Runs |
|---|---|---|---|
| `bx npm i` | `base`, `npm` | none | `npm i` |
| `bx +node npx foo` | `base`, `node` | none | `npx foo` |
| `bx -net npm i` | `base`, `npm` without `net` anywhere | none | `npm i` |
| `bx --share-net -- curl x` | `base`, `curl` | `--share-net` | `curl x` |
| `bx` | `base`, the shell's profile | none | `$SHELL` |

A command's profile is loaded only if the file exists. `-name` disables a
profile everywhere it would load, including nested includes; naming a profile
that does not exist is an error. Set `BX_DEBUG=1` to print the bwrap command
and any skipped profiles before it runs.

## 🗂️ Profiles

Profiles are files in `~/.bx/`. The `base` profile is always loaded first.

```sh
# ~/.bx/base
--die-with-parent
--new-session
--unshare-all
--share-net
--ro-bind / /
--dev /dev
--proc /proc
--tmpfs /tmp
--tmpfs $HOME
--bind $PWD $PWD
--chdir $PWD
```

```sh
# ~/.bx/go
include net-tools
--bind-try $HOME/go/pkg/mod $HOME/go/pkg/mod
--bind-try "$HOME/.cache/go-build" "$HOME/.cache/go-build"
```

bx passes flags to bwrap in this order: `base`, then the command's profile, then each `+name` profile in command-line order, then local `.bx` files, then flags from the command line. Each profile loads once. In bwrap, later flags override earlier ones, so `bx --unshare-net -- cmd` turns off the network that `base` turned on.

## 📍 Local profiles

A file named `.bx` in the working directory or any parent directory is loaded like a profile, after the `~/.bx/` profiles. Parent files load outermost first, the working directory's file last, so the closest file wins.

```sh
# ~/projects/app/.bx
include node
--bind ./node_modules /sandbox/node_modules
--setenv APP_CACHE $BX_DIR/.cache
```

Two extras apply only inside a local `.bx` file, not inside profiles it includes:

- `$BX_DIR` holds the directory of the `.bx` file.
- A word that starts with `./` or `../` resolves against the file's directory, no matter where bx runs. Bare words and flag values like `--perms 0755` stay untouched.

The names `.` and `..` stand for the local files in toggles: `-.` leaves out the working directory's `.bx`, `-..` leaves out all parent `.bx` files, and `-npm` next to them disables the `npm` profile as usual. Unlike other names, `-.` and `-..` are never errors when no such file exists.

> [!WARNING]
> bx loads `.bx` files without any trust check. A `.bx` file in a cloned repository can weaken or remove the sandbox. Check `.bx` files before you run bx in unfamiliar directories.

## ⚖️ Counter-profiles

Some bwrap flags can be undone by a later flag, and some cannot.

- For flags with an opposite (`--share-net` vs `--unshare-net`), keep a small counter-profile and add it with `+`:

  ```sh
  # ~/.bx/no-net
  --unshare-net
  ```

  `bx +no-net npm i` loads the `npm` profile but wins the network flag.

- For flags with no opposite (a `--bind` cannot be unbound later), disable the profile that adds them: `bx -npm npm i` runs npm with `base` only.

## 🛠️ Development

```sh
go test ./...
golangci-lint run ./...
```
