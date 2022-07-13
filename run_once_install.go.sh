#!/bin/bash

packages=(
    github.com/bufbuild/buf/cmd/buf@latest
    github.com/fullstorydev/grpcui/cmd/grpcui@latest
    github.com/grpc-ecosystem/grpcdebug@latest
    github.com/ktr0731/evans@latest
    github.com/mitranim/gow@latest
    github.com/terraform-docs/terraform-docs@latest
    sigs.k8s.io/kind@latest
)

for package in "${packages[@]}"; do
    go install "${package}"
done
