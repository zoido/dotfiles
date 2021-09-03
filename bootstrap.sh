#!/bin/bash

set -eo pipefail

OP_URL="https://raw.githubusercontent.com/zoido/dotfiles/main/dot_local/bin/executable_op"
BIN_DIR="${HOME}/.local/bin"
OP="${BIN_DIR}/op"
CHEZMOI="${BIN_DIR}/chezmoi"

install_chezmoi() {
    sh -c "$(curl -fsLS git.io/chezmoi)" -- -b "${BIN_DIR}"
}

download_op() {
    curl "${OP_URL}" -f --output "${OP}"
    chmod +x "${OP}"
}

bootstrap_op() {
    echo
    echo -n "Enter 1password account e-mail: "
    read -r OP_EMAIL
    echo

    while ! "${OP}" signin my "${OP_EMAIL}"; do
        echo "Try again."
    done
}

signin_op() {
    set +e
    while true; do
        op="$(${OP} signin)"
        [ "$?" -ne 0 ] && echo "Try again." && continue
        eval "${op}"
        break
    done
}

mkdir -p "${BIN_DIR}"

[ ! -f "${CHEZMOI}" ] && install_chezmoi
[ ! -f "${OP}" ] && download_op

if [ "${CODESPACES}" != "true" ]; then
    [ ! -f "${HOME}/.config/op/config" ] && bootstrap_op
    signin_op
fi

if [ "${CODESPACES}" == "true" ]; then
    SCRIPT_DIR="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"
    "${CHEZMOI}" init --apply zoido --source="$SCRIPT_DIR"
else
    "${CHEZMOI}" init --apply zoido
fi
