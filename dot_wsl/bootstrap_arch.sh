#!/bin/bash

set -eo pipefail

echo "Setting up pacman..."
pacman -Syyu --noconfirm
pacman -S sudo pwgen zsh --noconfirm

echo "Setting up sudoers..."
pwgen  16 1 | passwd  --stdin
pacman -S sudo pwgen --noconfirm
echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel

echo "Setting up default user..."
useradd -m -G wheel -s /usr/bin/zsh zoid
pwgen  16 1 | passwd zoid --stdin


echo "Configuring WSL..."
cat <<-"EOF" > /etc/wsl.conf
[interop]
enabled = true

[boot]
systemd=true

[user]
default = zoid
EOF
