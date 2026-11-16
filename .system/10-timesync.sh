#!/bin/bash

# Turns on time sync over NTP (network time protocol) and shows the clock status.

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

timedatectl set-ntp true
timedatectl status
