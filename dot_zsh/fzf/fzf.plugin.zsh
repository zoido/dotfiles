FZF_DEFAULT_OPTS="
    --height 20%
    --ansi
    --border=top
    --prompt='❯ '
    --pointer='❯'
    --marker='*'
    --color fg:white,hl:green,fg+:yellow,bg+:bright-black,hl+:green
    --color border:white,gutter:-1,info:gray
"

[ -e /usr/share/fzf/completion.zsh ] && . /usr/share/fzf/completion.zsh
[ -e /usr/share/fzf/key-bindings.zsh ] && . /usr/share/fzf/key-bindings.zsh
