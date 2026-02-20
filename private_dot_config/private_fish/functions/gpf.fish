# Force push with lease (safer than --force).
function gpf --description 'git push --force-with-lease'
    git push --force-with-lease --force-if-includes $argv
end
