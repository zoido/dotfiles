function ggBD --description 'Delete git branches with fzf multi-select'
    tv git-delete --inline | xargs --no-run-if-empty git branch -D
end
