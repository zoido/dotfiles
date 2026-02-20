# Switch to main branch (auto-detected).
function gcm --description 'git checkout main/master'
    git checkout (git_main_branch)
end
