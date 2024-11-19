" Vim-plug setup
let data_dir = '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin()
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
call plug#end()

" Change cursor shape in insert mode
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" Options
set mouse=a

" Colors
colorscheme desert

" Autocmds
augroup vimStartup
  au!
  " Jump to the last known cursor position
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif
  " Force syntax sync after entering the buffer or leaving insert mode
  autocmd BufEnter,InsertLeave * :syntax sync fromstart
augroup END
