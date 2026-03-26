alias md='mkdir -p'
alias rd='rmdir'
alias hx='helix'

# Better ls with exa
if command -q exa
    alias lls=(command -v ls)
    alias ls='exa'
    alias lsa='exa -a'
    alias lla='exa -la'
    alias llG='exa -l --git'
    alias lsG='exa --git'
    alias lst='exa --tree'
    alias lt='exa --tree'
    alias llt='exa -l --tree'
end

# Weather
alias weather='curl "wttr.in/Prague?m"'
alias moon='curl wttr.in/Moon'

# Global pipe aliases (using abbr --position anywhere)
abbr -a L --position anywhere --set-cursor "% | less"
abbr -a LL --position anywhere --set-cursor "%  &| less"
abbr -a M --position anywhere --set-cursor "% | most"
abbr -a MM --position anywhere --set-cursor "%  &| most"
abbr -a B --position anywhere --set-cursor "% | bat"
abbr -a BA --position anywhere --set-cursor "% | bat -A"
abbr -a BB --position anywhere --set-cursor "%  &| bat"
abbr -a BBA --position anywhere --set-cursor "%  &| bat -A"
abbr -a O --position anywhere --set-cursor "% | ov"
abbr -a OO --position anywhere --set-cursor "%  &| ov"

# Terraform
alias tf='terraform'
alias tfa='tf apply'
alias tfp='tf plan'
alias tfaaa='tfa --auto-approve'
alias tfd='tf destroy'
alias tfdaa='tfd --auto-approve'
alias tfi='tf init'


# Kubernetes
alias kube='kubectl'
alias k='kubectl'
alias kctx='kubectx'
alias kns='kubens'

# Worktrunk
alias wts='wt switch'
alias wtm='wtm switch (git_main_branch)'
alias wtc='wts --create'
alias wtcm='wts --create --base (git_current_branch)'
alias wto='wts --execute=opencode'
alias wtco='wtc --execute=opencode'
alias wtcmo='wtc --base (git_current_branch) --execute=opencode'
