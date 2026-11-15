#!/bin/bash

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

tty="tty1"
pam_file="/etc/pam.d/ly"

pacman -S --needed --noconfirm ly oo7

add_pam_line() {
    local type="$1"
    local line="$2"

    if grep -qxF -- "${line}" "${pam_file}"; then
        return
    fi

    local last
    last="$(grep -nE "^-?${type}[[:space:]]" "${pam_file}" | tail -n 1 | cut -d: -f1)"
    if [[ -z ${last} ]]; then
        echo "Error: ${pam_file} has no ${type} lines." >&2
        exit 1
    fi
    sed -i "${last}a ${line}" "${pam_file}"
}

add_pam_line auth "-auth      optional     pam_oo7.so"
add_pam_line password "-password  optional     pam_oo7.so"
add_pam_line session "-session   optional     pam_oo7.so auto_start"

systemctl disable "getty@${tty}.service"
systemctl enable "ly@${tty}.service"

echo "Reboot to start Ly on ${tty}."
