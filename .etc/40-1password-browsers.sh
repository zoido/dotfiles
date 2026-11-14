#!/bin/bash

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

browser="waterfox"
config_dir="/etc/1password"
config_file="${config_dir}/custom_allowed_browsers"

mkdir -p "${config_dir}"
touch "${config_file}"
grep -qxF "${browser}" "${config_file}" || echo "${browser}" >> "${config_file}"

chown root:root "${config_file}"
chmod 755 "${config_file}"

echo "Restart 1Password to use the new browser list."
