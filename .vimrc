"
" ~/.vimrc
"

source $VIMRUNTIME/defaults.vim

set colorcolumn=80 
set modeline
set mouse=nvi
set ttymouse=xterm2

colorscheme desert
highlight ColorColumn ctermbg=17

au BufRead,BufNewFile nextflow.config,*.nf setfiletype groovy

noremap <F12> <Esc>:syntax sync fromstart<CR>
inoremap <F12> <C-o>:syntax sync fromstart<CR>
autocmd BufEnter,InsertLeave * :syntax sync fromstart
