#!/bin/bash

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

conf_dir="/etc/systemd/resolved.conf.d"
conf_file="${conf_dir}/quad9.conf"
stub_resolv="/run/systemd/resolve/stub-resolv.conf"

mkdir -p "${conf_dir}"
cat > "${conf_file}" << 'EOF'
[Resolve]
DNS=9.9.9.9#dns.quad9.net
DNS=149.112.112.112#dns.quad9.net
DNS=2620:fe::fe#dns.quad9.net
DNS=2620:fe::9#dns.quad9.net
DNSOverTLS=yes
Domains=~.
EOF
chmod 644 "${conf_file}"

systemctl enable --now systemd-resolved.service

if [[ "$(readlink /etc/resolv.conf)" != "${stub_resolv}" ]]; then
    ln -sf "${stub_resolv}" /etc/resolv.conf
fi

systemctl restart systemd-resolved.service

resolvectl dns
resolvectl domain
resolvectl query --cache=no archlinux.org
