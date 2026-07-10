# Rename a branch locally and on the origin remote.
function grename --description 'Rename branch locally and on origin'
    if test (count $argv) -ne 2
        echo "Usage: grename old_branch new_branch"
        return 1
    end

    # Rename branch locally.
    git branch -m $argv[1] $argv[2]
    # Rename branch on origin remote.
    if git push origin :$argv[1]
        git push --set-upstream origin $argv[2]
    end
end
