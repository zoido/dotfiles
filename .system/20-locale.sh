#!/bin/bash

# Sets the system locale to English with ISO 8601 dates and Czech regional formats.

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

cat > /etc/locale.gen << 'EOF'
cs_CZ.UTF-8 UTF-8
en_DK.UTF-8 UTF-8
en_US.UTF-8 UTF-8
EOF
locale-gen

cat > /etc/locale.conf << 'EOF'
LANG=en_US.UTF-8
LC_TIME=en_DK.UTF-8
LC_NUMERIC=cs_CZ.UTF-8
LC_MONETARY=cs_CZ.UTF-8
LC_PAPER=cs_CZ.UTF-8
LC_MEASUREMENT=cs_CZ.UTF-8
LC_ADDRESS=cs_CZ.UTF-8
LC_TELEPHONE=cs_CZ.UTF-8
EOF
chmod 644 /etc/locale.gen /etc/locale.conf

cat /etc/locale.conf
echo "Log out and log in again to use the new locale."
