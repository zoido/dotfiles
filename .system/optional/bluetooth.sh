#!/bin/bash

# Installs Bluetooth utilities and bluetui, and turns on the bluetooth service.

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

pacman -S --needed --noconfirm bluez bluez-utils bluetui

systemctl enable --now bluetooth.service
