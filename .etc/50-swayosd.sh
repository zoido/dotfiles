#!/bin/bash

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

pacman -S --needed --noconfirm swayosd

systemctl enable --now swayosd-libinput-backend.service
