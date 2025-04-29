#!/bin/bash
set -e

yay -S --needed --noconfirm --sudoloop wsl2-ssh-agent wsl-open
sudo libtool --finish /usr/lib/libfakeroot
