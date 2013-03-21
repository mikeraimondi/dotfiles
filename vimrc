"	Set basics
set nocompatible
syntax on
filetype plugin indent on

" Install pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()
execute pathogen#helptags()

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

" Set up powerline
set rtp+=~/dotfiles/vim/bundle/powerline/powerline/bindings/vim
" Fix esc delay
if ! has('gui_running')
	set ttimeoutlen=10
	augroup FastEscape
		autocmd!
		au InsertEnter * set timeoutlen=0
		au InsertLeave * set timeoutlen=1000
	augroup END
endif

" Open NERDtree if no files are specified
autocmd vimenter * if !argc() | NERDTree | endif
" Exit Vim if NERDtree is the only open window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Do not fold on open
set foldlevel=10

" Set colors
if has('gui_running')
	set background=light
else
	set background=dark
endif
colorscheme solarized
"if $TERM == "xterm-256color" || $TERM == "screen-256color" || $COLORTERM == "gnome-terminal"
"	  set t_Co=256
	  "let g:zenburn_high_Contrast=1
		"colors zenburn
		"hi Visual cterm=reverse
		"hi LineNr ctermfg=7
		"hi Search cterm=reverse
		"hi Folded ctermfg=lightgray ctermbg=darkgray cterm=underline
"endif

" Set shortcuts
command -nargs=* E :Explore <args>
map <C-n> :NERDTreeToggle<CR>
map <C-c> :set paste!<CR>
map <F12> :make \|cwindow 10<CR>
