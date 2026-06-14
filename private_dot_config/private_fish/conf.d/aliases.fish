abbr -a md 'mkdir -p'
abbr -a rd 'rmdir'
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
abbr -a weather 'curl "wttr.in/Prague?m"'
abbr -a moon 'curl wttr.in/Moon'

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
abbr -a tf 'terraform'
abbr -a tfa 'terraform apply'
abbr -a tfp 'terraform plan'
abbr -a tfaaa 'terraform apply --auto-approve'
abbr -a tfd 'terraform destroy'
abbr -a tfdaa 'terraform destroy --auto-approve'
abbr -a tfi 'terraform init'

# Kubernetes
abbr -a kube 'kubectl'
abbr -a k 'kubectl'
abbr -a kctx 'kubectx'
abbr -a kctxc 'kubectx -c'
abbr -a kctxu 'kubectx -u'
abbr -a kcc 'kubectx -c'
abbr -a kcu 'kubectx -u'
abbr -a kns 'kubens'
abbr -a knsc 'kubens -c'
abbr -a knsu 'kubens -u'

# Worktrunk
abbr -a wts 'wt switch'
abbr -a wtm 'wt switch (git_main_branch)'
abbr -a wtc 'wt switch --create'
abbr -a wtcm 'wt switch --create --base (git_main_branch)'
abbr -a wto 'wt switch --execute=opencode'
abbr -a wtco 'wt switch --create --execute=opencode'
abbr -a wtcmo 'wt switch --create --base (git_main_branch) --execute=opencode'

# Opencode
abbr -a oc 'opencode'
abbr -a occ 'opencode --continue'
abbr -a ocp 'opencode --prompt'
abbr -a ocr 'opencode run'
abbr -a ocrc 'opencode run --continue'

# Custom scripts
abbr -a prnv please-release-new-version
