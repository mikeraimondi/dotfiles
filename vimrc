set nocompatible
set ruler
set numberwidth=5
set ts=2
set number
set shiftwidth=2
set copyindent
set autoindent
set hls
set laststatus=2
syntax enable
call pathogen#infect()
filetype plugin indent on
set bs=indent,eol,start

set t_Co=256
set background=dark
hi LineNr ctermfg=7
hi Search cterm=reverse

command -nargs=* E :Explore <args>
map <F5> :set paste!<CR>
