[ "$(command -v chezmoi)" ] && eval "$(chezmoi completion zsh)"
[ "$(command -v op)" ] && eval "$(op completion zsh)"
[ "$(command -v pew)" ] && source $(pew shell_config) || exit 0
