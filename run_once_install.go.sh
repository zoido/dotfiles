#!/bin/bash

packages=(
    github.com/ktr0731/evans@latest
)

for package in ${packages[*]}; do
    go install "${package}"
done
