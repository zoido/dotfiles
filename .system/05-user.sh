#!/bin/bash

# Installs fish and sudo, creates the user in the wheel group with fish as the shell, and lets the wheel group run all commands with sudo.
#
# If sudo is not installed yet, run this script as root, for example with su.

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

user="zoid"
groups="wheel"
shell="/usr/bin/fish"
sudoers_file="/etc/sudoers.d/wheel"

pacman -S --needed --noconfirm fish sudo

# useradd fails if the user exists, so the script uses usermod to set the same
# groups and shell for an existing user.
if id -u "${user}" &> /dev/null; then
    usermod -aG "${groups}" -s "${shell}" "${user}"
else
    useradd -m -G "${groups}" -s "${shell}" "${user}"
fi

# The script writes the rule to a temporary file first, because a sudoers file
# with an error can stop sudo from working. visudo makes sure that the file is
# correct before the script installs it.
tmp_file="$(mktemp)"
trap 'rm -f "${tmp_file}"' EXIT
echo "%wheel ALL=(ALL:ALL) ALL" > "${tmp_file}"
visudo -cf "${tmp_file}"
install -Dm440 -o root -g root "${tmp_file}" "${sudoers_file}"

echo "Change the password for ${user}."
