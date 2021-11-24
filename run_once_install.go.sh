#!/bin/bash

packages=(
    github.com/ktr0731/evans@latest
    github.com/bufbuild/buf/cmd/buf@v1.0.0-rc6
    github.com/fullstorydev/grpcui/cmd/grpcui@latest
)

for package in ${packages[*]}; do
    go install "${package}"
done
