#!/bin/bash

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

tty="tty1"

pacman -S --needed --noconfirm ly

systemctl disable "getty@${tty}.service"
systemctl enable "ly@${tty}.service"

echo "Reboot to start Ly on ${tty}."
