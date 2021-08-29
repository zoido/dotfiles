set nocompatible    " Don't try to be vi compatible
filetype off    " Helps force plugins to load correctly when it is turned back on below

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'VundleVim/Vundle.vim'  " let Vundle manage Vundle, required
Plugin 'crusoexia/vim-monokai'
Plugin 'phanviet/vim-monokai-pro'
Plugin 'nvie/vim-flake8'
Plugin 'sjl/vitality.vim'
Plugin 'scrooloose/syntastic'
Plugin 'plytophogy/vim-virtualenv'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'sheerun/vim-polyglot'

call vundle#end()
