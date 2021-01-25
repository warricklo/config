" Neovim configuration

" General

set nocompatible
filetype plugin on
filetype indent on
syntax on
set encoding=utf-8
set splitbelow splitright
set nowrap
set wildmode=longest,list,full
set lazyredraw
set ignorecase
set mouse=a
set guioptions=a
set nobackup nowritebackup
set list listchars=eol:¬,tab:»\ ,trail:∙,extends:›,precedes:‹

" Tabs

set noexpandtab
set shiftwidth=4
set tabstop=4
set softtabstop=0

" Line numbers

set number

" Comments

" Do not comment on newline.
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
