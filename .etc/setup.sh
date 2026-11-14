#!/bin/bash

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

for script in "${script_dir}"/[0-9][0-9]-*.sh; do
    echo "==> $(basename "${script}")"
    "${script}"
done
