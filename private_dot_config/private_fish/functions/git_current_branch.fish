# Returns the current git branch name.
function git_current_branch --description 'Get current git branch name'
    git branch --show-current 2>/dev/null
end
