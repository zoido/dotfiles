#!/bin/bash

set -eo pipefail


echo "Set root password..."
until passwd; do
  echo "Command failed, retrying..."
  sleep 1
done


echo "Setting up sudoers..."
echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel


echo "Setting up pacman..."
pacman-key --init
sudo pacman-key --populate
pacman -Syy --needed --noconfirm archlinux-keyring
cat <<-"EOF" >> /etc/pacman.conf
[wslutilities]
Server = https://pkg.wslutiliti.es/arch/
EOF
pacman -Syyu --noconfirm
pacman -S --noconfirm zsh


echo "Setting up default user..."
useradd -m -G wheel -s /usr/bin/zsh zoid
echo "Set user password..."
until passwd zoid; do
  echo "Command failed, retrying..."
  sleep 1
done
echo
echo
echo "Run 'Arch.exe config --default-user zoid' to set default user."