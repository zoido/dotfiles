#!/bin/bash

# Installs caps2esc, so that Caps Lock is Esc when you tap it and Ctrl when you hold it.

set -eo pipefail

[[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"

pacman -S --needed --noconfirm interception-tools interception-caps2esc

# The udevmon service reads this job and starts caps2esc for each input device
# that has a Caps Lock key.
install -Dm644 /dev/stdin /etc/interception/udevmon.d/caps2esc.yaml <<'EOF'
- JOB: intercept -g $DEVNODE | caps2esc | uinput -d $DEVNODE
  DEVICE:
    EVENTS:
      EV_KEY: [KEY_CAPSLOCK]
EOF

# The restart makes udevmon read the job again after a change.
systemctl enable udevmon.service
systemctl restart udevmon.service
