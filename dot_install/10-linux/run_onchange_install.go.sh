#!/bin/bash

packages=(
    github.com/boyter/scc/v3@latest
    github.com/bufbuild/buf/cmd/buf@latest
    github.com/doronbehar/pistol/cmd/pistol@latest
    github.com/fullstorydev/grpcui/cmd/grpcui@latest
    github.com/gokcehan/lf@latest
    github.com/hionay/tailer/cmd/tailer@latest
    github.com/kevwan/tproxy@latest
    github.com/loft-sh/vcluster/cmd/vclusterctl@latest
    github.com/noborus/ov@latest
    github.com/sachaos/viddy@latest
    github.com/stern/stern@latest
    github.com/terraform-docs/terraform-docs@latest
    mvdan.cc/gofumpt@latest
    sigs.k8s.io/kind@latest
)

for package in "${packages[@]}"; do
    go install -ldflags="-s -w" "${package}"
done
