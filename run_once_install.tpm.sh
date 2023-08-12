#!/bin/bash

HOME_=${HOME}
git clone https://github.com/tmux-plugins/tpm ${HOME_}/.tmux/plugins/tpm
${HOME_}/.tmux/plugins/tpm/bin/install_plugins
