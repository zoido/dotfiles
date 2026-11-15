#!/bin/bash

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

user="zoid"
conf_dir="/etc/ssh/sshd_config.d"
conf_file="${conf_dir}/10-hardening.conf"

pacman -S --needed --noconfirm openssh

mkdir -p "${conf_dir}"
cat > "${conf_file}" << EOF
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no
KbdInteractiveAuthentication no
AuthenticationMethods publickey
AllowUsers ${user}
EOF
chmod 644 "${conf_file}"

systemctl start sshdgenkeys.service
sshd -t

systemctl enable --now sshd.service
systemctl reload sshd.service

sshd -T | grep -Ei '^(permitrootlogin|pubkeyauthentication|passwordauthentication|kbdinteractiveauthentication|authenticationmethods|allowusers) '

authorized_keys="$(getent passwd "${user}" | cut -d: -f6)/.ssh/authorized_keys"
if [[ ! -s "${authorized_keys}" ]]; then
    echo "Warning: ${authorized_keys} is missing or empty. Add a public key before you log in over SSH." >&2
fi
