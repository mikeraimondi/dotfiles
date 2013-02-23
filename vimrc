"	Set basics
set nocompatible
syntax on
filetype plugin indent on

" Install pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()
execute pathogen#helptags()

" Set up powerline
set rtp+=~/dotfiles/vim/bundle/powerline/powerline/bindings/vim

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
map <C-h> :nohlsearch<CR>

" Set colors
if $TERM == "xterm-256color" || $TERM == "screen-256color" || $COLORTERM == "gnome-terminal"
	  set t_Co=256
endif
colors zenburn
hi LineNr ctermfg=7
hi Search cterm=reverse
hi Folded ctermfg=lightgray ctermbg=darkgray cterm=underline

" Set shortcuts
command -nargs=* E :Explore <args>
map <C-n> :NERDTreeToggle<CR>
map <F5> :set paste!<CR>
map <F6> :make \|cwindow 10<CR>
