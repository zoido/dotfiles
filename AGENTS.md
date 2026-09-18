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

## Editor Language Settings

[.helix/languages.toml](.helix/languages.toml) maps template files to their real language.
If you add a template whose name matches no glob there, add a glob for it:

- Named after a file ending: add `{ glob = "*.<ext>.tmpl" }` to the language.
- No file ending (for example `symlink_*` or `executable_*`): add `{ glob = "<file name>" }`.

Keep the plain file endings in each `file-types` list. Helix replaces the built-in list with this one.

## Testing

`chezmoi diff` to preview, `chezmoi apply -n` for dry run.
