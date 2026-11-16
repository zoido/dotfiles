#!/bin/bash

# Sets up hourly restic backups of this machine to Google Cloud Storage.
#
# The secrets come from 1Password through a service account. The service
# account token is encrypted with systemd-creds, and the TPM is used if the
# machine has one. The script asks for the token if it is not stored yet.
#
# The script installs the files in .system/restic. It copies restic.env,
# includes.txt, and excludes.txt to /etc/restic only if they do not exist. You
# edit these files for each machine. When you run the script again, it shows
# how they differ from the defaults in the repository.
#
# The script enables the timers only after you fill in restic.env and the
# repository exists.

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
src_dir="${script_dir}/restic"
conf_dir="/etc/restic"
env_file="${conf_dir}/restic.env"
token_name="restic-op-token"
token_file="/etc/credstore.encrypted/${token_name}"
timers=(restic-backup.timer restic-forget.timer restic-check.timer)

pacman -S --needed --noconfirm restic

# 1password-cli is in the AUR, so pacman cannot install it.
if ! command -v op > /dev/null; then
    echo "Error: op is not installed. Install the 1password-cli package from the AUR." >&2
    exit 1
fi

install -Dm755 "${src_dir}/restic-sys" /usr/local/bin/restic-sys
install -Dm755 "${src_dir}/restic-job" /usr/local/bin/restic-job
install -Dm644 "${src_dir}/restic@.service" /etc/systemd/system/restic@.service
for timer in "${timers[@]}"; do
    install -Dm644 "${src_dir}/${timer}" "/etc/systemd/system/${timer}"
done

install_once() {
    local src="$1"
    local dst="$2"
    local mode="$3"

    if [[ ! -e ${dst} ]]; then
        install -Dm"${mode}" "${src}" "${dst}"
        echo "Created ${dst}."
    elif ! cmp -s "${src}" "${dst}"; then
        echo "${dst} differs from the default in the repository:"
        diff -u --label "${dst}" --label default "${dst}" "${src}" || true
    fi
}

install -d -m 755 "${conf_dir}"
install_once "${src_dir}/restic.env.example" "${env_file}" 600
install_once "${src_dir}/includes.txt" "${conf_dir}/includes.txt" 644
install_once "${src_dir}/excludes.txt" "${conf_dir}/excludes.txt" 644

if [[ ! -s ${token_file} ]]; then
    if [[ ! -t 0 ]]; then
        echo "Error: ${token_file} is missing. Run the script in a terminal to enter the token." >&2
        exit 1
    fi
    read -rsp "1Password service account token: " token
    echo
    install -d -m 700 "$(dirname "${token_file}")"
    # Without --with-key, systemd-creds uses the TPM and the host key if the
    # machine has a TPM. Otherwise it uses only the host key.
    printf '%s' "${token}" | systemd-creds encrypt --name="${token_name}" - "${token_file}"
    unset token
    echo "Created ${token_file}."
fi

systemctl daemon-reload

if grep -Eq '^[^#]*<[^>]+>' "${env_file}"; then
    echo "Replace the <placeholders> in ${env_file}. Then run this script again."
    exit 0
fi

# "restic cat config" fails if the repository does not exist yet.
if ! restic-sys cat config > /dev/null; then
    echo "restic cannot open the repository."
    echo "If the repository does not exist yet, run \"sudo restic-sys init\"."
    echo "Then run this script again."
    exit 0
fi

systemctl enable --now "${timers[@]}"
systemctl list-timers "${timers[@]}"
