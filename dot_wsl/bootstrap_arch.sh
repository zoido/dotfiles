#!/bin/bash

set -eo pipefail


echo "Set root password..."
until passwd; do
  echo "Command failed, retrying..."
  sleep 1
done


echo "Setting up sudoers..."
echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel

echo "Arbitrary Pause..."
# This helps with the keyring setup below to succeed for some reason.
sleep 5

echo "Setting up pacman..."
pacman-key --init
pacman-key --populate
pacman -Syy --needed --noconfirm archlinux-keyring


if grep -qF "[wslutilities]" /etc/pacman.conf; then
  echo "wslutilities already in pacman.conf"
else
echo "Adding wslutilities to pacman.conf..."
cat <<-"EOF" >> /etc/pacman.conf
[wslutilities]
Server = https://pkg.wslutiliti.es/arch/
EOF
fi

curl https://pkg.wslutiliti.es/public.key | sudo pacman-key --add /dev/stdin
pacman-key --lsign-key 2D4C887EB08424F157151C493DD50AA7E055D853

pacman -Syyu --noconfirm
pacman -S --noconfirm zsh


echo "Setting up default user..."
useradd -m -G wheel -s /usr/bin/zsh zoid
echo "Set user password..."
until passwd zoid; do
  echo "Command failed, retrying..."
  sleep 1
done
