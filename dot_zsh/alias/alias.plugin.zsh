alias zshconfig="${EDITOR} ${HOME}/.zshrc"


# development conveniences
alias git-fullclean='git reset HEAD && git checkout . && git clean -fd'
alias gofumpt-split-lines='GOFUMPT_SPLIT_LONG_LINES="on" gofumpt -w .'

#  Better ls
if [ "$(command -v exa)" ]; then
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

alias -g O='| ov'
alias -g OO="2>&1 | ov"

# terraform
alias tf="terraform"
alias tfa="tf apply"
alias tfp="tf plan"
alias tfaaa="tfa --auto-approve"
alias tfd="tf destroy"
alias tfdaa="tfd --auto-approve"
alias tfi="tf init"

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
alias opsi='(umask 177 && touch $HOME/.op_session); eval $(op signin | tee $HOME/.op_session)'

# kubernetes
alias kube="kubectl"
alias k="kubectl"
alias kctx="kubectx"
alias kns="kubens"

# aws
func awsp() {
    local profile
    profile=$(sed -n "s/\[profile \(.*\)\]/\1/gp" ~/.aws/config | fzf)
    if [ -n "$profile" ]; then
        eval "$(AWS_PROFILE=$profile aws configure export-credentials --format env --profile "$profile")"
        export AWS_PROFILE=$profile
    fi
}

# git
alias -- --='git switch -'

func gB() {
    git branch | fzf | xargs git switch
}

func gBD() {
    git branch | fzf -m | xargs git branch -D
}
