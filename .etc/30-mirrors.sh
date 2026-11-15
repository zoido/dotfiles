#!/bin/bash

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

conf_file="/etc/xdg/reflector/reflector.conf"

pacman -S --needed --noconfirm reflector

mkdir -p "$(dirname "${conf_file}")"
cat > "${conf_file}" << 'EOF'
--save /etc/pacman.d/mirrorlist
--protocol https
--country Czechia,Germany,Poland
--latest 10
--sort rate
EOF
chmod 644 "${conf_file}"

systemctl enable --now reflector.timer
systemctl start reflector.service
head -n 20 /etc/pacman.d/mirrorlist
