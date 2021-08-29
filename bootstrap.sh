#!/bin/bash

set -euxo pipefail

OP_URL="https://raw.githubusercontent.com/zoido/dotfiles/main/dot_local/bin/executable_op"
OP_SIG_URL="https://raw.githubusercontent.com/zoido/dotfiles/main/dot_local/bin/op.sig"

go install "github.com/twpayne/chezmoi@latest"
# gpg --receive-keys 3FEF9748469ADBE15DA7CA80AC2D62742012EA22

mkdir -p "${HOME}/.local/bin"
curl "${OP_URL}" --output "${HOME}/.local/bin/op"
curl "${OP_SIG_URL}" --output "${HOME}/.local/bin/op.sig"

# gpg --verify \
#     "${HOME}/.local/bin/op.sig" \
#     "${HOME}/.local/bin/op"

echo -n "Enter 1password account e-mail"
read -r OP_EMAIL

"${HOME}/.local/bin/op" op signin my "${OP_EMAIL}"
eval "$(${HOME}/.local/bin/op signin my)"

${HOME}/go/bin/chezmoi init --apply zoido
