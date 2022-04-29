"	Set basics
set nocompatible
filetype off
syntax on

" Set preferred environment
set ruler
set numberwidth=5
set ts=2
set number
set shiftwidth=2
set copyindent
set autoindent
set laststatus=2
set bs=indent,eol,start
set encoding=utf-8

" Set search
set incsearch
set ignorecase
set smartcase
set hlsearch

" Needed for Fish shell
set shell=/bin/bash

" Set colors
if $TERM == "xterm-256color" || $TERM == "screen-256color" || $COLORTERM == "gnome-terminal"
	" Zenburn scheme
	"set t_Co=256
	"let g:zenburn_high_Contrast=1
	"colors zenburn
	"hi Visual cterm=reverse
	"hi LineNr ctermfg=7
	"hi Search cterm=reverse
	"hi Folded ctermfg=lightgray ctermbg=darkgray cterm=underline
endif
filetype plugin indent on

" Set shortcuts
command -nargs=* E :Explore <args>
map <C-n> :NERDTreeToggle<CR>
map <C-c> :set paste!<CR>
map <F12> :make \|cwindow 10<CR>
map <C-h> :nohlsearch<CR>
