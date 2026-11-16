#!/bin/bash

set -eo pipefail

BIN_DIR="${HOME}/.local/bin"
CHEZMOI="${BIN_DIR}/chezmoi"

install_chezmoi() {
    sh -c "$(curl -fsLS chezmoi.io/get)" -- -b "${BIN_DIR}"
}

mkdir -p "${BIN_DIR}"

[ ! -f "${CHEZMOI}" ] && install_chezmoi

"${CHEZMOI}" init --apply zoido
chezmoi update
