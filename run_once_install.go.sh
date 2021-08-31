#!/bin/bash

packages=(
    github.com/ktr0731/evans@latest
    github.com/bufbuild/buf/cmd/buf@latest
)

for package in ${packages[*]}; do
    go install "${package}"
done
