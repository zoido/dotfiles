# [`@zoido`](https://github.com/zoido)'s [dotfiles](https://dotfiles.github.io/)

Managed by [`chezmoi`](https://www.chezmoi.io/)

## Bootstrapping

### Generic

```sh
sh -c "$(curl -fsLS https://raw.githubusercontent.com/zoido/dotfiles/main/bootstrap.sh)"
```

### Arch Linux

```sh
pacman -Sy --needed chezmoi sudo
chezmoi init --apply zoido
```

### Termux

```sh
pkg install -y chezmoi git
chezmoi init --apply zoido
```

### Windows

```ps1
(irm -useb https://raw.githubusercontent.com/zoido/dotfiles/main/bootstrap.bat) | powershell -c -
```
