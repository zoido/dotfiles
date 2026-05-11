function gBD --description 'Delete git branches with fzf multi-select'
    git branch --sort=-committerdate |
    grep -v '^\*' |
    fzf -m --preview='git log --stat --decorate --color=always -1 {1}' |
    awk '{print $NF}' |
    xargs --no-run-if-empty git branch -D
end
