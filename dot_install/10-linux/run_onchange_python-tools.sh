#! /bin/bash

pip_packages=(
    pipx
)

pipx_packages=(
    black
    hatch
    http-prompt
    httpie
    ipython
    mitmproxy
    pew
    poetry
    polysh
    pytest
    ruff
    thefuck
    tldr
)

pip3 install --break-system-packages --user --upgrade --force-reinstall "${pip_packages[@]}" || exit 1

PIPX=${HOME}/.local/bin/pipx
for package in "${pipx_packages[@]}"; do
     ${PIPX} install --force $package
done

${PIPX} upgrade-all
