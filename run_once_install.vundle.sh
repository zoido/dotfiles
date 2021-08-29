#!/bin/bash

git clone https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim
vim -u "${HOME}/.vundle.vim" +PluginInstall +qall
