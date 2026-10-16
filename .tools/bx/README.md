<div align="center">

# 📦 bx

**Sandbox any command with [bubblewrap](https://github.com/containers/bubblewrap), using plain-text profiles.**

![Go](https://img.shields.io/badge/go-1.27-00ADD8?logo=go&logoColor=white)
![Platform](https://img.shields.io/badge/platform-linux-FCC624?logo=linux&logoColor=black)

</div>

```console
$ bx npm install           # Runs npm with the base and npm profiles.
$ bx @pi                   # Opens a shell with the pi profile.
$ bx --unshare-net -- make # Adds a bwrap flag for one run.
```

## ✨ Features

- **Profiles:** one bwrap flag per line, in a plain-text file.
- **Automatic selection:** `bx npm` loads `~/.bx/npm` if that file exists.
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
bx [@profile] command [args...]
bx [@profile] [bwrap flags...] [-- command [args...]]
```

| You type | Profiles | Extra bwrap flags | Runs |
|---|---|---|---|
| `bx npm i` | `base`, `npm` | none | `npm i` |
| `bx @node npx foo` | `base`, `node` | none | `npx foo` |
| `bx --share-net -- curl x` | `base`, `curl` | `--share-net` | `curl x` |
| `bx` | `base`, the shell's profile | none | `$SHELL` |

A command's profile is loaded only if the file exists. Set `BX_DEBUG=1` to print the bwrap command before it runs.

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

bx passes flags to bwrap in this order: `base`, then the selected profile, then flags from the command line. In bwrap, later flags override earlier ones, so `bx --unshare-net -- cmd` turns off the network that `base` turned on.

## 🛠️ Development

```sh
go test ./...
golangci-lint run ./...
```
