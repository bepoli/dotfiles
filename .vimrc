" Options
set autoindent
set autoread
set backspace=indent,eol,start
set colorcolumn=80
set display=truncate
set expandtab
set history=1000
set incsearch
set laststatus=2
set list
set listchars=trail:•,tab:>-
set mouse=nvi
set nocompatible
set ruler
set scrolloff=2
set shiftwidth=2
set showcmd
set softtabstop=2
set tabstop=2
set ttimeout
set ttimeoutlen=100
if has('mouse_sgr') | set ttymouse=sgr | endif
set wildmenu

" Colors
highlight ColorColumn ctermbg=8

" File types
au BufNewFile,BufRead *.nf,nextflow.config setfiletype groovy

" Fix broken syntax highlighting
noremap <F12> <Esc>:syntax sync fromstart<CR>
inoremap <F12> <C-o>:syntax sync fromstart<CR>

" Plugins settings
let g:slime_target = "tmux"

" Closing statements
filetype plugin indent on
syntax on
