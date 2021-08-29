#!/bin/bash

set -euo pipefail

OP_URL="https://raw.githubusercontent.com/zoido/dotfiles/main/dot_local/bin/executable_op"
BIN_DIR="${HOME}/.local/bin"
OP="${BIN_DIR}/op"
CHEZMOI="${BIN_DIR}/chezmoi"

mkdir -p "${BIN_DIR}"

if [ ! -f "${CHEZMOI}" ]; then
    sh -c "$(curl -fsLS git.io/chezmoi)" -- -b "${BIN_DIR}"
fi

if [ ! -f "${OP}" ]; then
    curl "${OP_URL}" -f --output "${OP}"
    chmod +x "${OP}"
fi

if [ ! -f "${HOME}/.config/op/config" ]; then
    echo
    echo -n "Enter 1password account e-mail: "
    read -r OP_EMAIL
    echo

    while ! "${OP}" signin my "${OP_EMAIL}"; do
        echo "Try again."
    done
fi


if ! "${OP}" get account; then
    set +e
    while true; do
        op="$(${OP} signin)"
        [ "$?" -ne 0 ] && echo "Try again." && continue
        eval "${op}"
        break
    done
fi

"${CHEZMOI}" init --apply zoido
