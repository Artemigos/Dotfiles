runtime bundle/vim-pathogen/autoload/pathogen.vim

execute pathogen#infect()
syntax on
filetype plugin indent on

set nocompatible

" C# method text objects
let g:method_regex='\(\(public\|private\|async\|static\|virtual\|abstract\|override\|new\|protected\|internal\)\s\+\)*\a\+\s\+\a\+\(<.\{-1,}>\)\=(.\{-})\_s\{-}{'
exec 'vnoremap am :<C-U>?'.g:method_regex.'<CR>v/{<CR>%'
exec 'vnoremap im :<C-U>?'.g:method_regex.'<CR>/{<CR>vi{'
omap am :normal vam<CR>
omap im :normal vim<CR>

" indenting settings
set modeline
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab

" non-printable characters
set list
set listchars=trail:-,tab:>\ ,extends:>,precedes:<,nbsp:+

" editor appearance
set relativenumber
set cursorline

" colors
set t_8f=[38;2;%lu;%lu;%lum
set t_8b=[48;2;%lu;%lu;%lum
set t_Co=256
set termguicolors
colors dracula

" quality of life
set wildmenu
set path+=**
let g:netrw_liststyle=3
let g:netrw_list_hide=netrw_gitignore#Hide()
set incsearch
set scrolloff=5
set sidescrolloff=5

if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif

set autoread
set showtabline=2
set laststatus=2

