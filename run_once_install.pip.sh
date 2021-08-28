#! /bin/bash

pip_packages=(
    pipx
)

pipx_packages=(
    black
    flake8
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
    thefuck
    tox
    yapf
)

pip3 install --user --upgrade --force-reinstall ${pip_packages[*]} || exit 1

for package in ${pipx_packages[*]}; do
    pipx install $package
done

pipx inject ptpython ipython sympy pdir2 better_exceptions
pipx upgrade-all
