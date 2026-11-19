#!/bin/bash

# Runs the laptop setup scripts in order, but only if this machine is a laptop.
#
# The script reads ~/.config/zoido/host/laptop, which chezmoi writes from the
# laptop value in the chezmoi configuration. If the value is false, the script
# does nothing.

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# The chezmoi source folder is in the home folder of the user, so the owner of
# the folder is that user. This also works when you run the script as root
# without sudo.
owner="$(stat -c %U "${script_dir}")"
laptop_file="$(getent passwd "${owner}" | cut -d: -f6)/.config/zoido/host/laptop"

scripts=(
    500-upower.sh
    510-iwd.sh
    520-backlight.sh
)

if [[ ! -f ${laptop_file} ]]; then
    echo "Error: ${laptop_file} is missing. Run chezmoi apply as ${owner}, then run this script again." >&2
    exit 1
fi

case "$(< "${laptop_file}")" in
    true) ;;
    false)
        echo "This machine is not a laptop. The script skips the laptop setup."
        exit 0
        ;;
    *)
        echo "Error: ${laptop_file} must contain true or false." >&2
        exit 1
        ;;
esac

for script in "${scripts[@]}"; do
    echo "==> laptop/${script}"
    "${script_dir}/${script}"
done
