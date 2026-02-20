function gB --description 'Switch git branch with fzf'
    git branch | fzf | xargs git switch
end
