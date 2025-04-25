#!/bin/bash

set -eo pipefail

echo "Setting up pacman..."
pacman -Sy --noconfirm reflector
reflector --save /etc/pacman.d/mirrorlist --country Czechia --protocol https --sort rate --latest 5
pacman -Syyu --noconfirm
pacman -S --noconfirm sudo pwgen zsh

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
