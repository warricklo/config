" Neovim configuration

" General

set nocompatible
filetype plugin on
filetype indent on
syntax on
set encoding=utf-8
set splitbelow splitright
set wrap
set wildmode=longest,list,full
set lazyredraw
set ignorecase
set mouse=a
set guioptions=a
set nobackup nowritebackup
set list listchars=eol:¬,tab:»\ ,trail:∙,extends:›,precedes:‹

" Tabs

set noexpandtab
set cindent
set softtabstop=0
set tabstop=8
set shiftwidth=8

" Line numbers

set number

" Comments

" Do not comment on newline.
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Miscellaneous

" Have :Q behave like :q.
command! Q :q
