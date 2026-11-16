#!/bin/bash

# Sets up systemd-resolved to send all DNS queries to Quad9 over TLS.

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

conf_dir="/etc/systemd/resolved.conf.d"
conf_file="${conf_dir}/quad9.conf"
stub_resolv="/run/systemd/resolve/stub-resolv.conf"

# DNSOverTLS=yes is strict mode. In strict mode, resolved does not send a DNS
# query as plain text. If resolved cannot open a TLS connection to a server,
# the lookup fails. This also applies to the DNS server that DHCP gives to the
# network link, for example a home router. Most routers do not support TLS, so
# resolved cannot use them.
#
# Domains=~. tells resolved to send all queries to the Quad9 servers first.
# Because of this, names on the local network that only the router knows do
# not resolve.
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

# Without this link, programs that read /etc/resolv.conf skip resolved and
# Quad9.
if [[ "$(readlink /etc/resolv.conf)" != "${stub_resolv}" ]]; then
    ln -sf "${stub_resolv}" /etc/resolv.conf
fi

systemctl restart systemd-resolved.service

resolvectl dns
resolvectl domain
resolvectl query --cache=no archlinux.org
