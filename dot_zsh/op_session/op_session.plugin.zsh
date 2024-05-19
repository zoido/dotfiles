OP_SESSION_PATH="${HOME}/.op_session"

op_session_preexec() {
    [ -e "${OP_SESSION_PATH}" ] && source "${OP_SESSION_PATH}"
}

add-zsh-hook preexec op_session_preexec
