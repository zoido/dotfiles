#! /bin/bash

pip_packages=(
    pipx
)

pipx_packages=(
    black
    flake8
    git-machete
    http-prompt
    httpie
    ipython
    mitmproxy
    pew
    pipenv
    pipenv-pipes
    poetry
    polysh
    ptpython
    pytest
    rich-cli
    thefuck
    tox
    yapf
)

pip3 install --break-system-packages --user --upgrade --force-reinstall "${pip_packages[*]}" || exit 1

PIPX=${HOME}/.local/bin/pipx
for package in ${pipx_packages[*]}; do
     ${PIPX} install --force $package
done

${PIPX} inject ptpython ipython sympy pdir2 better_exceptions
${PIPX} upgrade-all
