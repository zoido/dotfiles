#!/bin/bash

set -e

packages=(
    aria2
    atuin
    aws-cli-v2
    bat
    diff-so-fancy
    difftastic
    dive
    docker
    docker-buildx
    duf
    dust
    exa
    fd
    fx
    fzf
    github-cli
    go
    gping
    grpc_cli
    helm
    hexyl
    htop
    hyperfine
    jq
    k9s
    kubectl
    kubectx
    lazydocker
    lazygit
    libqalculate
    man-db
    mc
    most
    openssh
    peco
    procs
    protobuf
    python
    python-pip
    reflector
    ripgrep
    s3cmd
    skaffold
    socat
    starship
    step-cli
    terraform
    tfswitch
    traefik
    unzip
    uv
    viddy
    vim
    wget
    xdg-util
    yq
    zellij
    zoxide
    zsh
)

install_yay() {
    tmp=$(mktemp -d)
    trap "rm -rf ${tmp}" EXIT
    sudo pacman -Sy --needed git base-devel --noconfirm
    git clone https://aur.archlinux.org/yay.git "${tmp}"
    cd "${tmp}" || exit 1
    makepkg -si --noconfirm
}

pacman -Qs yay > /dev/null || install_yay
yay -Syyu --noconfirm --sudoloop


yay -Sy --needed --noconfirm --sudoloop ${packages[*]}

sudo libtool --finish /usr/lib/libfakeroot
