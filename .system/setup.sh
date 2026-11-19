#!/bin/bash

# Runs all system setup scripts in order.

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

scripts=(
    05-user.sh
    10-timesync.sh
    20-locale.sh
    30-mirrors.sh
    40-1password-browsers.sh
    50-swayosd.sh
    60-ly.sh
    70-xkb-zok.sh
    75-caps2esc.sh
    80-dns-quad9.sh
    85-docker.sh
    90-ssh.sh

    laptop/setup.sh
)

for script in "${scripts[@]}"; do
    echo "==> ${script}"
    "${script_dir}/${script}"
done
