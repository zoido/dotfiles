#!/bin/bash

# Installs swayosd and turns on its libinput backend.

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

pacman -S --needed --noconfirm swayosd

# The backend runs as a system service, because it reads the input devices
# directly. It tells the swayosd server when you press some special keys, for
# example the lock keys or the volume keys. The server then shows a popup for
# the key on the screen.
systemctl enable --now swayosd-libinput-backend.service
