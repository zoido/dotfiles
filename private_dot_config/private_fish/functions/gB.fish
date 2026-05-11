function gB --description 'Switch git branch with fzf'
    git branch --sort=-committerdate |
    grep -v '^\*' |
    fzf --preview='git log --stat --decorate --color=always -1 {1}' |
    awk '{print $NF}' |
    xargs --no-run-if-empty git switch
end
