#
# Z_ ZSH Theme
#

NEWLINE='
'

# PROMPT
Z_PROMPT_ADD_NEWLINE=true
Z_PROMPT_SEPARATE_LINE=true
Z_PROMPT_TRUNC=3

if [[ $EUID -ne 0 ]]; then
    Z_PROMPT_SYMBOL=%%
else
    Z_PROMPT_SYMBOL=#
fi

# PREFIXES
Z_PREFIX_SHOW=false
Z_PREFIX_HOST="@"
Z_PREFIX_ENV_DEFAULT=""
Z_PREFIX_DIR=""
Z_PREFIX_GIT="git:"
Z_PREFIX_MERCURIAL="hg:"
Z_PREFIX_NVM="nvm:"
Z_PREFIX_VENV="py:"
Z_PREFIX_CITC="citc:"

# GIT
Z_GIT_SHOW=true
Z_GIT_UNCOMMITTED="+"
Z_GIT_UNSTAGED="!"
Z_GIT_UNTRACKED="?"
Z_GIT_STASHED="$"
Z_GIT_UNPULLED="_"
Z_GIT_UNPUSHED="^"

# GIT
Z_MERCURIAL_SHOW=true
Z_MERCURIAL_MODIFIED="*"
Z_MERCURIAL_ADDED="+"
Z_MERCURIAL_REMOVED="x"
Z_MERCURIAL_MISSING="!"
Z_MERCURIAL_NOT_TRACKED="?"

# NVM
Z_NVM_SHOW=true

# VENV
Z_VENV_SHOW=true

# VI_MODE
Z_VI_MODE_SHOW=true
Z_VI_MODE_INSERT=[I]
Z_VI_MODE_NORMAL=[N]green

# EXEC_TIME
Z_EXEC_TIME_SHOW=true
Z_TIME_TRESHOLD=5

# TIME_STAMP
Z_TIMESTAMP_SHOW=true

# citc
Z_CITC_SHOW=true

# Username.
# If user is root, then pain it in red. Otherwise, just print in yellow.
z_user() {
  if [[ $USER == 'root' ]]; then
    echo -n "%{$fg_bold[red]%}"
  else
    echo -n "%{$fg[yellow]%}"
  fi
  echo -n "%n"
  echo -n "%{$reset_color%}"
}

# Username and SSH host
# If there is an ssh connections, then show user and current machine.
# If user is not $USER, then show username.
z_host() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo -n "$NEWLINE"
    echo -n "$(z_user)"

    # Do not show directory prefix if prefixes are disabled
    [[ $Z_PREFIX_SHOW == true ]] && echo -n "${Z_PREFIX_HOST}"
    # Display machine name
    echo -n "%{$fg[white]%}%m%{$reset_color%}"
    # Do not show host prefix if prefixes are disabled
    [[ $Z_PREFIX_SHOW == true ]] && echo -n "${Z_PREFIX_DIR}"
    echo -n "$NEWLINE"

  elif [[ $LOGNAME != $USER ]] || [[ $USER == 'root' ]]; then
    echo -n "$NEWLINE"
    echo -n "$(z_user)"

    # Do not show host prefix if prefixes are disabled
    [[ $Z_PREFIX_SHOW == true ]] && echo -n "${Z_PREFIX_DIR}"

    echo -n "$NEWLINE"
    echo -n "%{$reset_color%}"
  fi
}

# Current directory.
# Return only three last items of path
z_current_dir() {
  echo -n "%{$fg[cyan]%}"
  echo -n "%${Z_PROMPT_TRUNC}~";
  echo -n "%{$reset_color%}"
}

# Uncommitted changes.
# Check for uncommitted changes in the index.
z_git_uncomitted() {
  if ! $(git diff --quiet --ignore-submodules --cached); then
    echo -n "${Z_GIT_UNCOMMITTED}"
  fi
}

# Unstaged changes.
# Check for unstaged changes.
z_git_unstaged() {
  if ! $(git diff-files --quiet --ignore-submodules --); then
    echo -n "${Z_GIT_UNSTAGED}"
  fi
}

# Untracked files.
# Check for untracked files.
z_git_untracked() {
  if [ -n "$(git ls-files --others --exclude-standard)" ]; then
    echo -n "${Z_GIT_UNTRACKED}"
  fi
}

# Stashed changes.
# Check for stashed changes.
z_git_stashed() {
  if $(git rev-parse --verify refs/stash &>/dev/null); then
    echo -n "${Z_GIT_STASHED}"
  fi
}

# Unpushed and unpulled commits.
# Get unpushed and unpulled commits from remote and draw arrows.
z_git_unpushed_unpulled() {
  # check if there is an upstream configured for this branch
  command git rev-parse --abbrev-ref @'{u}' &>/dev/null || return

  local count
  count="$(command git rev-list --left-right --count HEAD...@'{u}' 2>/dev/null)"
  # exit if the command failed
  (( !$? )) || return

  # counters are tab-separated, split on tab and store as array
  count=(${(ps:\t:)count})
  local arrows left=${count[1]} right=${count[2]}

  (( ${right:-0} > 0 )) && arrows+="${Z_GIT_UNPULLED}"
  (( ${left:-0} > 0 )) && arrows+="${Z_GIT_UNPUSHED}"

  [ -n $arrows ] && echo -n "${arrows}"
}

# Git status.
# Collect indicators, git branch and pring string.
z_git_status() {
  [[ $Z_GIT_SHOW == false ]] && return

  # Check if the current directory is in a Git repository.
  command git rev-parse --is-inside-work-tree &>/dev/null || return

  # Check if the current directory is in .git before running git checks.
  if [[ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]]; then
    # Ensure the index is up to date.
    git update-index --really-refresh -q &>/dev/null

    # String of indicators
    local indicators=''

    indicators+="$(z_git_uncomitted)"
    indicators+="$(z_git_unstaged)"
    indicators+="$(z_git_untracked)"
    indicators+="$(z_git_stashed)"
    indicators+="$(z_git_unpushed_unpulled)"

    [ -n "${indicators}" ] && indicators="(${indicators})";

    # Do not show git prefix if prefixes are disabled
    [[ $Z_PREFIX_SHOW == true ]] && echo -n "${Z_PREFIX_GIT}"

    echo -n "%{$fg[blue]%}"
    echo -n "$(git_current_branch)"
    echo -n "$indicators"
    echo -n "%{$reset_color%} "
  fi
}

z_mercurial_status() {
  [[ $Z_MERCURIAL_SHOW == false ]] && return
  local hg_branch=$(echo `hg branch 2> /dev/null`)
  [ -n "$hg_branch" ] || return

  local hg_status="$(hg status)"
  # String of indicators
  local indicators=''

  [ -n "$(echo $hg_status | grep -E '^\s*\M')" ] && indicators+="${Z_MERCURIAL_MODIFIED}"
  [ -n "$(echo $hg_status | grep -E '^\s*\A')" ] && indicators+="${Z_MERCURIAL_ADDED}"
  [ -n "$(echo $hg_status | grep -E '^\s*\R')" ] && indicators+="${Z_MERCURIAL_REMOVED}"
  [ -n "$(echo $hg_status | grep -E '^\s*\!')" ] && indicators+="${Z_MERCURIAL_MISSING}"
  [ -n "$(echo $hg_status | grep -E '^\s*\?')" ] && indicators+="${Z_MERCURIAL_NOT_TRACKED}"

  [ -n "${indicators}" ] && indicators="(${indicators})";

  # Do not show mercurial prefix if prefixes are disabled
  [[ $Z_PREFIX_SHOW == true ]] && echo -n "${Z_PREFIX_MERCURIAL}"

  local hg_bookmark=$(hg id -B)

  echo -n "%{$fg[yellow]%}"
  [ -n "$hg_bookmark" ] && echo -n "@$hg_bookmark" || echo -n "$hg_branch"
  echo -n "$indicators"
  echo -n "%{$reset_color%} "
}

# Virtual environment.
# Show current virtual environment (Python).
z_venv_status() {
  [[ $Z_VENV_SHOW == false ]] && return

  # Check if the current directory running via Virtualenv
  # [ -n "$VIRTUAL_ENV" ] && $(type deactivate >/dev/null 2>&1) || return
  [ -n "$VIRTUAL_ENV" ] || return

  # Do not show venv prefix if prefixes are disabled
  [[ $Z_PREFIX_SHOW == true ]] && echo -n "${Z_PREFIX_VENV}"

  echo -n "%{$fg[magenta]%}"
  echo -n "$(basename $VIRTUAL_ENV)"
  echo -n "%{$reset_color%}"
}

# NVM
# Show current version of node, exception system.
z_nvm_status() {
  [[ $Z_NVM_SHOW == false ]] && return

  $(type nvm >/dev/null 2>&1) || return

  local nvm_status=$(nvm current 2>/dev/null)
  [[ "${nvm_status}" == "system" ]] && return
  nvm_status=${nvm_status}

  # Do not show NVM prefix if prefixes are disabled
  [[ ${Z_PREFIX_SHOW} == true ]] && echo -n "${Z_PREFIX_NVM}"

  echo -n "%{$fg[green]%}"
  echo -n "${nvm_status}"
  echo -n "%{$reset_color%}"
}

# Temporarily switch to vi-mode
z_enable_vi_mode() {
  function zle-keymap-select() { zle reset-prompt; zle -R; };
  zle -N zle-keymap-select;
  bindkey -v;
}

# Show current vi_mode mode
z_vi_mode() {
  if bindkey | grep "vi-quoted-insert" > /dev/null 2>&1; then # check if vi-mode enabled
    echo -n "%{$fg[white]%}"

    MODE_INDICATOR="${Z_VI_MODE_INSERT}"

    case ${KEYMAP} in
      main|viins)
      MODE_INDICATOR="${Z_VI_MODE_INSERT}"
      ;;
      vicmd)
      MODE_INDICATOR="${Z_VI_MODE_NORMAL}"
      ;;
    esac
    echo -n "${MODE_INDICATOR}"
    echo -n "%{$reset_color%} "
  fi
}

# time stamp
z_timestamp () {
  echo -n "%{$FG[008]%}"
  [[ $Z_TIMESTAMP_SHOW == true ]] && echo -n `date '+%H:%M:%S(%z)'`
  echo -n "%{$reset_color%}"
}

# exec time
preexec() {
  cmd_timestamp=`date +%s`
}

precmd() {
  [[ $Z_EXEC_TIME_SHOW == false ]] && return
  local stop=`date +%s`
  local start=${cmd_timestamp:-$stop}
  let Z_last_exec_duration=$stop-$start
  cmd_timestamp=''
}

displaytime () {
  local T=$1
  local D=$((T/60/60/24))
  local H=$((T/60/60%24))
  local M=$((T/60%60))
  local S=$((T%60))
  [[ $D > 0 ]] && printf '%dd' $D
  [[ $H > 0 ]] && printf '%dh' $H
  [[ $M > 0 ]] && printf '%dm' $M
  printf '%ds' $S
}

z_exec_time() {
  [[ $Z_EXEC_TIME_SHOW == false ]] && return
  if [ "$Z_last_exec_duration" -gt "$Z_TIME_TRESHOLD" ]; then
    echo -n "%{$fg[yellow]%}"
    echo -n "$(displaytime $Z_last_exec_duration)"
    echo -n "$FG[008]%}|%{$reset_color%}"
  fi
}

# citc
z_citc() {
    [[ $Z_CITC_SHOW == false ]] && return
    local match
    if [[ $PWD =~ '^/google/src/cloud/([^/]+)/([^/]+)' ]]; then
        CITC_PATH=${${PWD#$MATCH}:-/}   # path relative to the g4 client; '/' if at top
        [[ $match[1] != $USER ]] && CITC_OWNER=$match[1]   # client owner, if not you
        CITC_NAME=${match[2]}           # the client name
        [[ $Z_PREFIX_SHOW == true ]] && echo -n "${Z_PREFIX_CITC}"
        echo -n "%{$fg[red]%}"
        echo -n "${CITC_NAME}"
        if pwd | grep -q "google3/javatests"; then
          echo -n "(jt)"
        elif pwd | grep -q "google3/java"; then
          echo -n "(j)"
        fi
        echo -n "%{$reset_color%} "
     fi
}


# Command prompt.
# Pain $PROMPT_SYMBOL in red if previous command was fail and
# pain in green if all OK.
z_return_status_prompt_sign() {
  echo -n "%(?.%{$fg[green]%}.%{$fg[red]%})"
  echo -n "${Z_PROMPT_SYMBOL}"
  echo    "%{$reset_color%}"
}

z_return_code() {
  echo -n "%(?..%{$fg[red]%}%?%{$FG[008]%}|%{$reset_color%})"
}

# Build prompt line
z_build_prompt() {
  z_citc
  z_mercurial_status
  z_git_status
  z_nvm_status
  z_venv_status
  echo -n $NEWLINE
  z_current_dir
  z_host
}

z_build_rprompt() {
  z_return_code
  z_exec_time
  z_timestamp
}

# Disable python virtualenv environment prompt prefix
VIRTUAL_ENV_DISABLE_PROMPT=true

# Compose PROMPT
PROMPT=''
[[ $Z_PROMPT_ADD_NEWLINE == true ]] && PROMPT="$PROMPT$NEWLINE"
PROMPT="$PROMPT"'$(z_build_prompt) '
[[ $Z_PROMPT_SEPARATE_LINE == true ]] && PROMPT="$PROMPT$NEWLINE"
[[ $Z_VI_MODE_SHOW == true ]] && PROMPT="$PROMPT"'$(z_vi_mode)'
PROMPT="$PROMPT"'$(z_return_status_prompt_sign) '

# Set PS2 - continuation interactive prompt
PS2="%{$fg[yellow]%}"
PS2+="%{$Z_PROMPT_SYMBOL%} "
PS2+="%{$reset_color%}"

RPROMPT=''
RPROMPT="$RPROMPT"'$(z_build_rprompt)'

# LSCOLORS
export LSCOLORS="Gxfxcxdxbxegedabagacab"
export LS_COLORS='no=00:fi=00:di=01;34:ln=00;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=41;33;01:ex=00;32:ow=0;41:*.cmd=00;32:*.exe=01;32:*.com=01;32:*.bat=01;32:*.btm=01;32:*.dll=01;32:*.tar=00;31:*.tbz=00;31:*.tgz=00;31:*.rpm=00;31:*.deb=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.lzma=00;31:*.zip=00;31:*.zoo=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.tb2=00;31:*.tz2=00;31:*.tbz2=00;31:*.avi=01;35:*.bmp=01;35:*.fli=01;35:*.gif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mng=01;35:*.mov=01;35:*.mpg=01;35:*.pcx=01;35:*.pbm=01;35:*.pgm=01;35:*.png=01;35:*.ppm=01;35:*.tga=01;35:*.tif=01;35:*.xbm=01;35:*.xpm=01;35:*.dl=01;35:*.gl=01;35:*.wmv=01;35:*.aiff=00;32:*.au=00;32:*.mid=00;32:*.mp3=00;32:*.ogg=00;32:*.voc=00;32:*.wav=00;32:*.patch=00;34:*.o=00;32:*.so=01;35:*.ko=01;31:*.la=00;33'
# Zsh to use the same colors as ls
# Link: http://superuser.com/a/707567
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
