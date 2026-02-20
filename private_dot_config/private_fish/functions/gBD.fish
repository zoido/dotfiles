function gBD --description 'Delete git branches with fzf multi-select'
    git branch | fzf -m | xargs git branch -D
end
