[ "$(command -v argo)" ] && source <(argo completion zsh) || true
[ "$(command -v chezmoi)" ] && eval "$(chezmoi completion zsh)"
[ "$(command -v hatch)" ] && source <(_HATCH_COMPLETE=zsh_source hatch)
[ "$(command -v helm)" ] && source <(helm completion zsh)
[ "$(command -v kind)" ] && source <(kind completion zsh)
[ "$(command -v kubectl)" ] && source <(kubectl completion zsh)
[ "$(command -v op)" ] && eval "$(op completion zsh)"
[ "$(command -v pew)" ] && source $(pew shell_config) || true
[ "$(command -v pipx)" ] && eval "$(register-python-argcomplete pipx)"
[ "$(command -v uv)" ] && source <(uv generate-shell-completion zsh)
