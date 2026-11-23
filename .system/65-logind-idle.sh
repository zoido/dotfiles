#!/bin/bash

# Sets up logind to suspend the computer after 15 minutes of idle time.

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

conf_dir="/etc/systemd/logind.conf.d"
conf_file="${conf_dir}/idle.conf"

# logind suspends the computer when all sessions are idle and no program holds
# an idle inhibitor lock. A video player can hold such a lock, for example.
mkdir -p "${conf_dir}"
cat > "${conf_file}" << 'EOF'
[Login]
IdleAction=suspend
IdleActionSec=15min
EOF
chmod 644 "${conf_file}"

# A reload makes logind read its configuration again. A restart of logind would
# stop the sessions that run now.
systemctl reload systemd-logind.service
