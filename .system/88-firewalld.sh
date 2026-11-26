#!/bin/bash

# Installs firewalld and turns on its service.

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

pacman -S --needed --noconfirm firewalld

systemctl enable --now firewalld.service
