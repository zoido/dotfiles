#!/bin/bash

# Installs the Ly display manager on tty1 and unlocks the oo7 keyring at login.
#
# Ly is a display manager with a text interface. oo7 is the secret service, the
# program that keeps passwords for other apps.

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

tty="tty1"
pam_file="/etc/pam.d/ly"

pacman -S --needed --noconfirm ly oo7

add_pam_line() {
    local type="$1"
    local line="$2"

    if grep -qxF -- "${line}" "${pam_file}"; then
        return
    fi

    local last
    last="$(grep -nE "^-?${type}[[:space:]]" "${pam_file}" | tail -n 1 | cut -d: -f1)"
    if [[ -z ${last} ]]; then
        echo "Error: ${pam_file} has no ${type} lines." >&2
        exit 1
    fi
    sed -i "${last}a ${line}" "${pam_file}"
}

# The pam_oo7.so module sends the password that you type in Ly to oo7, so the
# keyring unlocks when you log in. The keyring unlocks only if its password is
# the same as your login password.
#
# - The auth line keeps the password while Ly checks it.
# - The password line changes the keyring password when you change your login
#   password with passwd.
# - The session line sends the password to oo7 after login. The auto_start
#   option starts oo7-daemon-login if oo7 does not run yet.
#
# Each line starts with "-", so PAM skips it if the module is not installed.
# /etc/pam.d/ly is a backup file of the ly package. If a new version of Ly
# changes this file, pacman writes the new version to /etc/pam.d/ly.pacnew and
# keeps your file.
add_pam_line auth "-auth      optional     pam_oo7.so"
add_pam_line password "-password  optional     pam_oo7.so"
add_pam_line session "-session   optional     pam_oo7.so auto_start"

# The script does not start Ly now, because that would stop a session that
# runs on the tty.
systemctl disable "getty@${tty}.service"
systemctl enable "ly@${tty}.service"

echo "Reboot to start Ly on ${tty}."
