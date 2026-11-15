abbr -a md 'mkdir -p'
abbr -a rd rmdir

# Better ls with eza
if command -q eza
    alias lls=(command -v ls)
    alias ls='eza'
    alias lsa='eza -a'
    alias lla='eza -la'
    alias llG='eza -l --git'
    alias lsG='eza --git'
    alias lst='eza --tree'
    alias lt='eza --tree'
    alias llt='eza -l --tree'
end

# Weather
abbr -a weather 'curl "wttr.in/Prague?m"'
abbr -a moon 'curl wttr.in/Moon'

# Global pipe aliases (using abbr --position anywhere)
abbr -a L --position anywhere --set-cursor "% | less"
abbr -a LL --position anywhere --set-cursor "%  &| less"
abbr -a B --position anywhere --set-cursor "% | bat"
abbr -a BA --position anywhere --set-cursor "% | bat -A"
abbr -a BB --position anywhere --set-cursor "%  &| bat"
abbr -a BBA --position anywhere --set-cursor "%  &| bat -A"
abbr -a O --position anywhere --set-cursor "% | ov"
abbr -a OO --position anywhere --set-cursor "%  &| ov"

# Kubernetes
abbr -a kube kubectl
abbr -a k kubectl
abbr -a kctx kubectx
abbr -a kctxc 'kubectx -c'
abbr -a kctxu 'kubectx -u'
abbr -a kcc 'kubectx -c'
abbr -a kcu 'kubectx -u'
abbr -a kns kubens
abbr -a knsc 'kubens -c'
abbr -a knsu 'kubens -u'

# Worktrunk
abbr -a wts 'wt switch'
abbr -a wtsb 'wt switch --branches'
abbr -a wtm 'wt switch (git_main_branch)'
abbr -a wtc 'wt switch --create'
abbr -a wtcm 'wt switch --create --base (git_main_branch)'
abbr -a wtr 'wt remove'
abbr -a wtrf 'wt remove --force'

# Pi
abbr -a pi 'jai pi'
abbr -a pic 'jai pi -c'
abbr -a pir 'jai pi -r'
abbr -a picr 'jai pi --tools -edit,-write "/review"'
abbr -a picrt 'jai pi --tools -edit,-write "/tuicr-review"'
# Non-interactive variants of the abbreviations above for scripts, for example `fish -c xpicr`.
alias xpicr 'jai pi --tools -edit,-write,+set_exit_code "/review" --print'
alias xpicrt 'jai pi --tools -edit,-write,+set_exit_code "/tuicr-review" --print'

# Custom scripts
abbr -a prnv please-release-new-version

# Televisionm
abbr -a mmk 'tv make-targets --inline'
