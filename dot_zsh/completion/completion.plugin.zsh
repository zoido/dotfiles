[ "$(command -v argo)" ] && source <(argo completion zsh) || true
[ "$(command -v chezmoi)" ] && eval "$(chezmoi completion zsh)"
[ "$(command -v helm)" ] && source <(helm completion zsh)
[ "$(command -v kubectl)" ] && source <(kubectl completion zsh)
[ "$(command -v op)" ] && eval "$(op completion zsh)"
[ "$(command -v pew)" ] && source $(pew shell_config) || true
[ "$(command -v kind)" ] && source <(kind completion zsh)
