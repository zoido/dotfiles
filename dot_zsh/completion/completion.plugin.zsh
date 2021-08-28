fpath[1,0]=/usr/share/zsh/site-functions

# google sdk
[ -e "${HOME}.local/google-cloud-sdk/completion.zsh.inc" ] \
    && source "${HOME}.local/google-cloud-sdk/completion.zsh.inc"

# Hashi
autoload -U +X bashcompinit && bashcompinit

which consul &> /dev/null && complete -o nospace -C $(which consul) consul
which nomad &> /dev/null && complete -o nospace -C  $(which nomad) nomad
which vault &> /dev/null && complete -o nospace -C $(which vault) vault
which terraform &> /dev/null && complete -o nospace -C $(which terraform) terraform


# tools
which pew &> /dev/null && source $(pew shell_config)

# Bazel
fpath[1,0]=/usr/local/lib/bazel/bin

compinit
