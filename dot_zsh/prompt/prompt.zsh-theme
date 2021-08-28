my_dir=${0:a:h}

which starship > /dev/null && eval "$(starship init zsh)" || source "${my_dir}/.my_prompt.zsh"
