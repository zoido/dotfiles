#!/bin/bash

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

entry_country="CZ"
env_file="/etc/conf.d/cachyos-rate-mirrors.env"

pacman -S --needed --noconfirm rate-mirrors cachyos-rate-mirrors

mkdir -p "$(dirname "${env_file}")"
touch "${env_file}"
if grep -q '^RATE_MIRRORS_ENTRY_COUNTRY=' "${env_file}"; then
    sed -i "s/^RATE_MIRRORS_ENTRY_COUNTRY=.*/RATE_MIRRORS_ENTRY_COUNTRY=${entry_country}/" "${env_file}"
else
    echo "RATE_MIRRORS_ENTRY_COUNTRY=${entry_country}" >> "${env_file}"
fi

if systemctl cat reflector.timer &> /dev/null; then
    systemctl disable --now reflector.timer
fi

systemctl enable cachyos-rate-mirrors.timer
cachyos-rate-mirrors
