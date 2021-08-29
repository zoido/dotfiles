#!/bin/bash

gpg --verify \
    "${HOME}/.local/bin/op.sig" \
    "${HOME}/.local/bin/op" \
    &> /dev/null || exit 2
