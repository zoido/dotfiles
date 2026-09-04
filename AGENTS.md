# Chezmoi Dotfiles

These are my personal dotfiles managed with [chezmoi](https://chezmoi.io/).
They are organized to be modular and reusable across different environments.

## File Naming

- `dot_` → `.` prefix, `private_` → 0600 perms, `executable_` → +x, `.tmpl` → Go template
- `run_onchange_` / `run_once_` → scripts triggered by chezmoi

## Templates

- Variables defined in [.chezmoi.yaml.tmpl](.chezmoi.yaml.tmpl): `{{ .wsl }}`, `{{ .codespaces }}`, `{{ .archlinux }}`
- Package lists in [.chezmoidata/](.chezmoidata/) (iterate with `{{- range .packages.archlinux }}`)
- Reusable fragments in [.chezmoitemplates/](.chezmoitemplates/)

## Adding Packages

Add to `.chezmoidata/*.yaml` → install scripts in `dot_install/` iterate over these lists.

## Theme

Everything uses Catppuccin. `{{ .appearance }}` is `dark` or `light`; `{{ .catppuccin.flavor }}`
resolves to `{{ .catppuccin.dark }}` (macchiato) or `{{ .catppuccin.light }}` (latte).

Switch the appearance and re-render:

```sh
chezmoi init --prompt --promptChoice appearance=light
chezmoi apply
```

Some tools follow the terminal or desktop on their own and ignore `.appearance`:
bat (`--theme=auto`), zellij (`theme_dark`/`theme_light`), tuicr (`appearance = "system"`),
opencode (the `catppuccin-adaptive` theme). Change those in their own config, not here.

`gh-dash` has its own `{{ }}` syntax, so its template uses `[[ ]]` delimiters.

## Testing

`chezmoi diff` to preview, `chezmoi apply -n` for dry run.
