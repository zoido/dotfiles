# Returns the main branch name (main, master, trunk, etc.).
function git_main_branch --description 'Get main branch name'
    command git rev-parse --git-dir &>/dev/null; or return

    for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default,stable,master}
        if command git show-ref -q --verify $ref
            echo (basename $ref)
            return 0
        end
    end

    # Fallback: try to get the default branch from remote HEAD symbolic refs.
    for remote in origin upstream
        set -l ref (command git rev-parse --abbrev-ref $remote/HEAD 2>/dev/null)
        if string match -q "$remote/*" $ref
            string replace "$remote/" "" $ref
            return 0
        end
    end

    # If no main branch was found, fall back to master but return error.
    echo master
    return 1
end
