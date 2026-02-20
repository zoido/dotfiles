function gBP --description 'Find parent branch of current HEAD'
    set -l current (git rev-parse --abbrev-ref HEAD)

    for candidate in (git for-each-ref --format='%(refname:short)' refs/heads/)
        if test "$candidate" = "$current"
            continue
        end

        if git merge-base --is-ancestor "$candidate" HEAD
            set -l distance (git rev-list --count "$candidate..HEAD")
            echo "$distance $candidate"
        end
    end | sort -n | head -n 1 | awk '{print $2}'
end
