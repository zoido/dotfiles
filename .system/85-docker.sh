#!/bin/bash

# Installs Docker, turns on the Docker socket, and adds the user zoid to the docker group.

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

user="zoid"
group="docker"

pacman -S --needed --noconfirm docker

# The script turns on only the socket. systemd starts the Docker daemon when a
# client connects to the socket for the first time, so the daemon does not run
# until you use it.
systemctl enable --now docker.socket

# A member of the docker group can use the Docker socket without sudo. This
# gives the user the same access as root.
usermod -aG "${group}" "${user}"

echo "Log out and log in again, so that ${user} gets the ${group} group."
