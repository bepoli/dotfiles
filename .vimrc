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
