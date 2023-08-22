#! /bin/bash

pip_packages=(
    pipx
)

pipx_packages=(
    black
    euporie
    flake8
    git-machete
    hatch
    http-prompt
    httpie
    ipython
    mitmproxy
    pew
    poetry
    polysh
    ptpython
    pytest
    rich-cli
    thefuck
)

pip3 install --break-system-packages --user --upgrade --force-reinstall "${pip_packages[@]}" || exit 1

PIPX=${HOME}/.local/bin/pipx
for package in "${pipx_packages[@]}"; do
     ${PIPX} install --force $package
done

${PIPX} inject ptpython ipython sympy pdir2 better_exceptions
${PIPX} inject euporie jupyter

${PIPX} upgrade-all
