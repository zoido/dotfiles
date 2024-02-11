# [`@zoido`](https://github.com/zoido)'s [dotfiles](https://dotfiles.github.io/)

Managed by [`chezmoi`](https://www.chezmoi.io/)

## Bootstrapping

<details>
<summary>For WSL:  boostrap first as root...</summary>

```sh
sh -c "$(curl -fsLS https://raw.githubusercontent.com/zoido/dotfiles/main/dot_archlinux/bootstrap_wsl.sh)"
```
----
</details>

```sh
sh -c "$(curl -fsLS https://raw.githubusercontent.com/zoido/dotfiles/main/bootstrap.sh)"
```

### Windows

```ps1
(irm -useb https://raw.githubusercontent.com/zoido/dotfiles/main/dot_windows/bootstrap.bat) | powershell -c -
```
