# Returns the current git branch name.
function git_current_branch --description 'Get current git branch name'
    git rev-parse --abbrev-ref HEAD 2>/dev/null
end
