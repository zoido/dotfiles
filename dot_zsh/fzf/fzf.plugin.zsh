[ "$(command -v fd)" ] && FZF_DEFAULT_COMMAND='fd --type f'

export FZF_DEFAULT_OPTS="
  --preview-window='border-rounded'
  --prompt='❯ '
  --pointer='❯'
  --marker='*'
  --layout='reverse'
  --info='right'
"

[ -e /usr/share/fzf/completion.zsh ] && . /usr/share/fzf/completion.zsh
[ ! "$(command -v atuin)" ] && [ -e /usr/share/fzf/key-bindings.zsh ] && . /usr/share/fzf/key-bindings.zsh
