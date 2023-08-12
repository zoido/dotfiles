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

for package in ${pipx_packages[*]}; do
    ${HOME}/.local/bin/pipx install --force $package
done

pipx inject ptpython ipython sympy pdir2 better_exceptions
pipx upgrade-all
