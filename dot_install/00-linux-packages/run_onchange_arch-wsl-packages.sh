#!/bin/bash
set -e

yay -S --needed --noconfirm --sudoloop wslu
sudo libtool --finish /usr/lib/libfakeroot
