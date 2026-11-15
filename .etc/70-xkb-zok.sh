#!/bin/bash

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
layout="zok"

install -Dm644 "${script_dir}/../private_dot_config/xkb/symbols/${layout}" "/etc/xkb/symbols/${layout}"

echo "Restart espanso to use the new layout."
