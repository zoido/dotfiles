#!/bin/bash

set -e

packages=(
    fzf
    tmux
)

sudo apt-get update
sudo apt-get install -y ${packages[*]}

sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y -b ~/.local/bin
