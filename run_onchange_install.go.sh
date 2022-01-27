#!/bin/bash

packages=(
    github.com/ktr0731/evans@latest
    github.com/bufbuild/buf/cmd/buf@v1.0.0-rc11
    github.com/fullstorydev/grpcui/cmd/grpcui@latest
    sigs.k8s.io/kind@v0.11.1
)

for package in ${packages[*]}; do
    go install "${package}"
done
