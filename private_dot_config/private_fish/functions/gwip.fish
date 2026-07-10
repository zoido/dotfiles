# Create a WIP commit with all changes.
function gwip --description 'Commit WIP (work in progress)'
    git add -A
    git rm (git ls-files --deleted) 2>/dev/null
    git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"
end
