#!/bin/bash

set -euxo pipefail

OP_URL="https://raw.githubusercontent.com/zoido/dotfiles/main/dot_local/bin/executable_op"
BIN_DIR="${HOME}/.local/bin"
OP="${BIN_DIR}/op"

mkdir -p "${BIN_DIR}"

sh -c "$(curl -fsLS git.io/chezmoi)" -- -b "${BIN_DIR}"

curl "${OP_URL}" --f --output "${OP}"
chmod +x "${OP}"

set +x
echo
echo -n "Enter 1password account e-mail: "
read -r OP_EMAIL
echo
set -x

"${OP}" signin my "${OP_EMAIL}"
eval "$(${OP} signin my)"

"${BIN_DIR}/chezmoi" init --apply zoido
