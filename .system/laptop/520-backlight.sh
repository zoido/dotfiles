#!/bin/bash

# Installs brightnessctl and adds the user to the video group, so that the user can change the screen brightness.

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

user="zoid"
group="video"

# brightnessctl changes the brightness through logind, so it does not need the
# video group. It can also change the brightness of the keyboard light.
pacman -S --needed --noconfirm brightnessctl

# The brightness keys run swayosd, which writes the brightness value directly
# to the backlight file in /sys. The udev rule of swayosd gives the video group
# write access to this file.
usermod -aG "${group}" "${user}"

echo "Log out and log in again, so that ${user} gets the ${group} group."
