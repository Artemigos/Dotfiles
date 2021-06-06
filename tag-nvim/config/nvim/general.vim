" colors
syntax enable
set termguicolors
colorscheme dracula

" indenting settings
set modeline " read vim indent settings from within files
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab

" non-printable characters
set list
set listchars=trail:⋅,tab:→\ ,extends:❯,precedes:❮

" editor appearance
set relativenumber
set number
set cursorline
set foldcolumn=auto:9

" quality of life
set wildmenu
set path+=**
let g:netrw_liststyle=3
let g:netrw_list_hide=netrw_gitignore#Hide()
set incsearch
set scrolloff=5
set sidescrolloff=5
set formatoptions+=j " Delete comment character when joining commented lines
set autoread
set showtabline=2
set laststatus=2
set splitright
set splitbelow
set noswapfile

command! W w

" leader
let g:mapleader = ' '
let g:maplocalleader = ','

