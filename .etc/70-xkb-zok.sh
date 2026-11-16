#!/bin/bash

# Copies the zok keyboard layout to /etc/xkb so that espanso can read it.
#
# Espanso has the cap_dac_override capability, so that it can read /dev/input
# and write /dev/uinput. Because of this capability, libxkbcommon ignores $HOME
# and $XDG_CONFIG_HOME in the espanso process. Espanso cannot read ~/.config/xkb,
# so it reads the layout from /etc/xkb. Niri continues to use the copy in
# ~/.config/xkb.
#
# Run the script again after you change the layout.

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
layout="zok"

install -Dm644 "${script_dir}/../private_dot_config/xkb/symbols/${layout}" "/etc/xkb/symbols/${layout}"

echo "Restart espanso to use the new layout."
