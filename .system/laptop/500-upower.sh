#!/bin/bash

# Installs UPower and starts its service, so that apps can read the battery status.

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

pacman -S --needed --noconfirm upower

systemctl enable --now upower.service
upower -e
