#!/bin/bash

GIT_CONFIG_GLOBAL='' git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm
GIT_CONFIG_GLOBAL='' ${HOME}/.tmux/plugins/tpm/bin/install_plugins
