:command G !gcc -g % -o%< 
:command G32 !gcc -m32 -g  % -o%<32
:command Gr !gcc -g % -o%< && ./%<
:command Gr32 !gcc -m32 -g  % -o%<32 && ./%<32

 syntax on
 set number
 set ruler

call plug#begin('~/.vim/plugged')

Plug 'jiangmiao/auto-pairs'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

" Initialize plugin system
call plug#end()
set rtp+=~/.fzf


:map <C-F> :FZF<CR>
