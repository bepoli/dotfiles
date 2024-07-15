" Install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
unlet data_dir

" Vim-plug plugins
call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" Coc.nvim extensions
let g:coc_global_extensions = ['coc-json', 'coc-sh', 'coc-pyright']

" File type associations
autocmd BufRead,BufNewFile nextflow.config,*.nf setfiletype groovy | setlocal expandtab tabstop=4 softtabstop=4 shiftwidth=4
autocmd BufEnter,InsertLeave * :syntax sync fromstart

" Options
set colorcolumn=80

" Colors
colorscheme wildcharm
highlight ColorColumn ctermbg=238
