#!/bin/bash

set -e

yay  --needed --noconfirm --sudoloop -U ~/.local/share/chezmoi/dot_archlinux/fake-docker-1.0.0-1-any.pkg.tar.zst
yay -S --needed --noconfirm --sudoloop wslu

sudo libtool --finish /usr/lib/libfakeroot
