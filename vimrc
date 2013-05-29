"	Set basics
set nocompatible
syntax on
filetype plugin indent on

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

" Load plugins only on the latest versions
if (v:version >= 703) && (has("patch754"))
	" Install pathogen
	runtime bundle/vim-pathogen/autoload/pathogen.vim
	let g:pathogen_disabled = []
	silent! execute pathogen#infect()
	silent! execute pathogen#helptags()

	" Set up powerline
	" set rtp+=~/dotfiles/vim/bundle/powerline/powerline/bindings/vim
	" Hide mode text below powerline
	set noshowmode
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

	" JFold should not fold on open
	set foldlevel=10

	" Set syntax checkers
	let g:syntastic_ruby_checkers=['mri']

	" Set colors
	if $TERM == "xterm-256color" || $TERM == "screen-256color" || $COLORTERM == "gnome-terminal"
		" Solarized scheme
		" if has('gui_running')
		"	set background=light
		"else
		"	set background=dark
		"endif
		"colorscheme solarized
		" Zenburn scheme
		"set t_Co=256
		"let g:zenburn_high_Contrast=1
		"colors zenburn
		"hi Visual cterm=reverse
		"hi LineNr ctermfg=7
		"hi Search cterm=reverse
		"hi Folded ctermfg=lightgray ctermbg=darkgray cterm=underline
	endif
endif

" Set shortcuts
command -nargs=* E :Explore <args>
map <C-n> :NERDTreeToggle<CR>
map <C-c> :set paste!<CR>
map <F12> :make \|cwindow 10<CR>
map <C-h> :nohlsearch<CR>
