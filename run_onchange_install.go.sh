#!/bin/bash

packages=(
    github.com/ktr0731/evans@latest
    github.com/bufbuild/buf/cmd/buf@latest
    github.com/fullstorydev/grpcui/cmd/grpcui@latest
    sigs.k8s.io/kind@v0.11.1
)

for package in ${packages[*]}; do
    go install "${package}"
done
