set nocompatible
set ruler
set background=dark
set numberwidth=5
set ts=2
set number
set shiftwidth=2
set copyindent
set autoindent
set hls
set laststatus=2
syntax enable
set t_Co=256
call pathogen#infect()
filetype plugin indent on
set bs=indent,eol,start
hi LineNr ctermfg=7
command -nargs=* E :Explore <args>
map <F5> :set paste!<CR>
