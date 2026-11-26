#!/bin/bash

# Installs iwd and the impala Wi-Fi app, and gives the Wi-Fi card a new random MAC address each time that iwd starts.
#
# The script does nothing if the machine has no Intel Wi-Fi card.

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

driver="iwlwifi"
conf_file="/etc/iwd/main.conf"

# The iwlwifi kernel driver runs all Intel Wi-Fi cards.
has_intel_wifi() {
    local link
    for link in /sys/class/net/*/device/driver; do
        [[ "$(basename "$(readlink -f "${link}")")" == "${driver}" ]] && return 0
    done
    return 1
}

if ! has_intel_wifi; then
    echo "No network device uses the ${driver} driver. The script skips the iwd setup."
    exit 0
fi

pacman -S --needed --noconfirm iwd impala

# With AddressRandomization=once, iwd gives the card a new random MAC address
# when iwd starts, for example after a reboot. The address stays the same for
# all networks until iwd starts again. The full range also changes the first 3
# bytes, which identify the maker of the card.
#
# With EnableNetworkConfiguration=true, iwd gets the IP address with its own
# DHCP client.
mkdir -p "$(dirname "${conf_file}")"
cat > "${conf_file}" << 'EOF'
[General]
AddressRandomization=network
AddressRandomizationRange=full
EnableNetworkConfiguration=true
EOF
chmod 644 "${conf_file}"

was_active=false
systemctl is-active --quiet iwd.service && was_active=true

systemctl enable --now iwd.service

# A restart stops the Wi-Fi connection for a short time, so the script does not
# restart iwd when it ran before.
if [[ ${was_active} == true ]]; then
    echo "Restart iwd to use the new configuration: sudo systemctl restart iwd"
fi
