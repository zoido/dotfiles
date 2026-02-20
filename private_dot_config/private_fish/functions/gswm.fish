# Switch to main branch (auto-detected).
function gswm --description 'git switch main/master'
    git switch (git_main_branch)
end
