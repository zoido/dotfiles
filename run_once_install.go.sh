#!/bin/bash

packages=(

)

for package in ${packages[*]}; do
    go install "${package}"
done
