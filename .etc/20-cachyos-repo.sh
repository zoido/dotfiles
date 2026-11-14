#!/bin/bash

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

if grep -q '^\[cachyos' /etc/pacman.conf; then
    echo "CachyOS repositories are already in /etc/pacman.conf."
    exit 0
fi

tmp="$(mktemp -d)"
trap 'rm -rf -- "${tmp}"' EXIT

git clone --depth 1 https://github.com/CachyOS/cachyos-repo-add-script.git "${tmp}"
cd "${tmp}"
./cachyos-repo.sh
