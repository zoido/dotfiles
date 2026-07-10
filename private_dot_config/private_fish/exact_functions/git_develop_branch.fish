# Returns the develop branch name (dev, devel, develop, development).
function git_develop_branch --description 'Get develop branch name'
    command git rev-parse --git-dir &>/dev/null; or return

    for branch in dev devel develop development
        if command git show-ref -q --verify refs/heads/$branch
            echo $branch
            return 0
        end
    end

    echo develop
    return 1
end
