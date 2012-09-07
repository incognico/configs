" ~/.vimrc
" nico -> #/dev/null -> irc.rizon.net

set bs=2
set et
set gdefault
set hidden
set history=512
set hlsearch
set hlsearch
set ignorecase
set incsearch
"set list
set listchars=tab:▸\ ,eol:¬,trail:·
set modelines=0
"set mouse=a
set noai
set nocompatible
set nomodeline
set ruler
set showmatch
set smartcase
set smartcase
set smarttab
set sw=3
set t_Co=256
set t_vb= "shut the fuck up
set ts=3
"set undofile

"set term=linux
set enc=utf-8
set encoding=utf-8
set fenc=utf-8
scriptencoding utf-8
set termencoding=utf-8

filetype plugin on
filetype indent on
syntax on

au BufRead,BufNewFile *.tt set filetype=html

try
    let g:inkpot_black_background=1
    colorscheme inkpot
catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme ron
endtry

nnoremap / /\v
vnoremap / /\v

map Q gq
map <F11> :set invpaste<CR>
set pastetoggle=<F11>

let g:html_use_css=1

fixdel
