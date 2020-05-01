call plug#begin(stdpath('data') . '/plugged')
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'liuchengxu/vim-which-key'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround',
Plug 'tpope/vim-repeat',
Plug 'easymotion/vim-easymotion'
" Plug 'OmniSharp/omnisharp-vim'
Plug 'tpope/vim-fugitive'
call plug#end()

syntax on
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
set listchars=trail:-,tab:>\ ,extends:>,precedes:<,nbsp:+

" editor appearance
set relativenumber
set number
set cursorline

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

" leader
let g:mapleader = ' '
let g:maplocalleader = ','

" working with init.vim
command! Einit e $MYVIMRC " edit init.vim
command! Sinit source $MYVIMRC "source init.vim
nnoremap <Leader>ie :Einit<CR>
nnoremap <Leader>is :Sinit<CR>

au! BufWritePost $MYVIMRC source $MYVIMRC

" buffer switching
nnoremap <C-n> :bn<CR>
nnoremap <C-p> :bp<CR>
nnoremap <Leader>bn :bn<CR>
nnoremap <Leader>bp :bp<CR>

" split switching
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <Leader>wh <C-w>h
nnoremap <Leader>wj <C-w>j
nnoremap <Leader>wk <C-w>k
nnoremap <Leader>wl <C-w>l

" coc
source $XDG_CONFIG_HOME/nvim/coc.vim

" which-key
call which_key#register('<Space>', "g:which_key_map")
let g:which_key_map =  {}

nnoremap <silent> <Leader> :<C-u>WhichKey '<Space>'<CR>
nnoremap <silent> <LocalLeader> :<C-u>WhichKey ','<CR>

let g:which_key_map.b = {
            \ 'name': '+buffers',
            \ 'n': ['bn', 'next-buffer'],
            \ 'p': ['bp', 'previous-buffer'],
            \ }

let g:which_key_map.i = {
            \ 'name': '+init.vim',
            \ 'e': ['Einit', 'edit-init.vim'],
            \ 's': ['Sinit', 'source-init.vim'],
            \ }

let g:which_key_map.w = {
            \ 'name': '+windows',
            \ 'h': ['<C-w>h', 'left-window'],
            \ 'j': ['<C-w>j', 'bottom-window'],
            \ 'k': ['<C-w>k', 'top-window'],
            \ 'l': ['<C-w>l', 'right-window'],
            \ }

let g:which_key_map.f = {
            \ 'name': '+fzf',
            \ 'f': ['FZF-find', 'find'],
            \ 'g': ['FZF-git', 'git-ls-files'],
            \ }

" fzf
nnoremap <Leader>ff :call fzf#run(fzf#wrap({'source': 'find'}))<CR>
nnoremap <Leader>fg :call fzf#run(fzf#wrap({'source': 'git ls-files -co --exclude-standard'}))<CR>

" easymotion
map <Leader><Leader>h <Plug>(easymotion-linebackward)
map <Leader><Leader>l <Plug>(easymotion-lineforward)

" OmniSharp
" let g:OmniSharp_server_stdio = 1

