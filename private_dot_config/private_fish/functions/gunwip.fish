# Undo the last WIP commit if it was a WIP commit.
function gunwip --description 'Undo last WIP commit'
    set -l last_msg (git rev-list --max-count=1 --format="%s" HEAD 2>/dev/null | tail -1)
    if string match -q "*--wip--*" $last_msg
        git reset HEAD~1
    end
end
