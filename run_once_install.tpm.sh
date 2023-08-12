=#!/bin/bash

HOME_=${HOME}
HOME= git clone https://github.com/tmux-plugins/tpm ${HOME_}/.tmux/plugins/tpm
${HOME_}/.tmux/plugins/tpm/bin/install_plugins
