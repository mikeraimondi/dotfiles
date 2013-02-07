"	Set basics
set nocompatible
syntax on
filetype plugin indent on

" Install pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" Set preferred environment
set ruler
set numberwidth=5
set ts=2
set number
set shiftwidth=2
set copyindent
set autoindent
set hls
set laststatus=2
set bs=indent,eol,start

" Color settings
set t_Co=256
set background=dark
hi LineNr ctermfg=7
hi Search cterm=reverse
hi Folded ctermfg=lightgray ctermbg=darkgray cterm=underline

" Set shortcuts
command -nargs=* E :Explore <args>
map <F5> :set paste!<CR>
map <F6> :make \|cwindow 10<CR>
