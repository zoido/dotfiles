alias zshconfig="${EDITOR} ${HOME}/.zshrc"
alias git-fullclean='git reset HEAD && git checkout . && git clean -fd'

#  Better ls
if [ "$(command -v logo-ls)" ]; then
    alias lls="$(command -v ls)"
    alias ls='exa'
    alias lsa='exa -a'
    alias lla='exa -la'
    alias llG='exa -l --git'
    alias lsG='exa --git'
    alias lst='exa --tree'
    alias lt='exa --tree'
    alias llt='exa -l --tree'
fi

# utils
alias fzb="fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'"

# Weather
alias weather='curl "wttr.in/Prague?m"'
alias moon='curl wttr.in/Moon'

# Conveniently pipes
alias -g L='| less'
alias -g LL="2>&1 | less"

alias -g M='| most'
alias -g MM="2>&1 | most"

alias -g B='| bat'
alias -g BA='| bat -A'
alias -g BB="2>&1 | bat"
alias -g BBA="2>&1 | bat -A"

# terraform
alias tf="terraform"
alias tfa="tf apply"
alias tfp="tf plan"
alias tfaaa="tfa --auto-approve"
alias tfd="tf destroy"
alias tfdaa="tfd --auto-approve"
alias tfi="tf init"

# Tokens
alias nomad-admin='vault read -field=secret_id nomad/creds/admin | read NOMAD_TOKEN; export NOMAD_TOKEN'
alias consul-admin='vault read -field token consul/creds/admin | sed p | tr \n \  | read CONSUL_HTTP_TOKEN CONSUL_TOKEN; export CONSUL_TOKEN; export CONSUL_HTTP_TOKEN'
alias vault-admin-token='vault token create --ttl=10m -role=vault-root'
alias terraform-wrapper-token='vault token create -field=token -ttl=30m -role=terraform-wrapper | read VAULT_TERRAFORM_WRAPPER_TOKEN; export VAULT_TERRAFORM_WRAPPER_TOKEN'

# Bazel
alias b='bazel'
alias bb='b build'
alias bb.="bb '...'"
alias bb/="bb '//...'"
alias bt="b test --test_output=errors"
alias bt.="bt '...'"
alias bt/="bt '//...'"
alias br='b run'
alias bq='b query'
alias bcl='b clean'
alias bclx='bcl --expunge'

alias ib='ibazel'

alias ibt='ib test --test_output=errors'
alias ibt.="ibt '...'"
alias ibt/="ibt '//...'"

alias ibb='ib build '
alias ibb.="ibb '...'"
alias ibb/="ibb '//...'"

alias ibr="ib run"


# op
alias opsi='eval $(op signin)'
