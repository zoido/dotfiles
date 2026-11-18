#!/bin/bash

# Sets up a daily backup of the LUKS headers to /var/lib/luks-header.
#
# The hourly restic backup includes /var/lib, so it copies the headers to the
# restic repository. Run 95-restic.sh first.
#
# To restore a header, follow luks-header/RESTORE.md.

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
src_dir="${script_dir}/luks-header"
service="luks-header-backup.service"
timer="luks-header-backup.timer"

pacman -S --needed --noconfirm cryptsetup diffutils

install -Dm755 "${src_dir}/luks-header-backup" /usr/local/bin/luks-header-backup
install -Dm644 "${src_dir}/${service}" "/etc/systemd/system/${service}"
install -Dm644 "${src_dir}/${timer}" "/etc/systemd/system/${timer}"

systemctl daemon-reload
systemctl enable --now "${timer}"

# The first backup runs now, so the copies exist before the timer runs.
systemctl start "${service}"
journalctl --no-pager --output=cat --unit="${service}" --since=-1min
systemctl list-timers "${timer}"
