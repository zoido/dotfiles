#!/bin/bash

packages=(
    github.com/bufbuild/buf/cmd/buf@latest
    github.com/fullstorydev/grpcui/cmd/grpcui@latest
    github.com/kevwan/tproxy@latest
    github.com/terraform-docs/terraform-docs@latest
    mvdan.cc/gofumpt@latest
    sigs.k8s.io/kind@latest

    # Modern DNS client.
    github.com/mr-karan/doggo/cmd/doggo@latest

    # Conventional commits.
    github.com/muandane/goji@latest

    # LF file manager and friends.
    github.com/gokcehan/lf@latest
    github.com/doronbehar/pistol/cmd/pistol@latest

    # LOC counting.
    github.com/boyter/scc/v3@latest

    # Kubernetes logs tools.
    github.com/stern/stern@latest
    github.com/hionay/tailer/cmd/tailer@latest

    # Pager.
    github.com/noborus/ov@latest

    # Watch alternative.
    github.com/sachaos/viddy@latest

    # Shell snippets manager.
    github.com/knqyf263/pet@latest
)

for package in "${packages[@]}"; do
    go install -ldflags="-s -w" "${package}"
done
