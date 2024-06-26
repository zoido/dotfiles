#!/bin/bash

set -eo pipefail

BIN_DIR="${HOME}/.local/bin"
CHEZMOI="${BIN_DIR}/chezmoi"

install_chezmoi() {
    sh -c "$(curl -fsLS chezmoi.io/get)" -- -b "${BIN_DIR}"
}

mkdir -p "${BIN_DIR}"

[ ! -f "${CHEZMOI}" ] && install_chezmoi

if [ "${CODESPACES}" == "true" ]; then
    SCRIPT_DIR="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"
    "${CHEZMOI}" init --apply zoido --source="$SCRIPT_DIR"
else
    "${CHEZMOI}" init --apply zoido
fi
chezmoi update
