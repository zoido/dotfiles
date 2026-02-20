# Switch to develop branch (auto-detected).
function gswd --description 'git switch develop'
    git switch (git_develop_branch)
end
