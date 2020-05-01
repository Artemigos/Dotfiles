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
set listchars=space:⋅,tab:→\ ,extends:❯,precedes:❮

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
command! EditInit e $MYVIMRC " edit init.vim
command! SourceInit source $MYVIMRC "source init.vim
nnoremap <Leader>ie :EditInit<CR>
nnoremap <Leader>is :SourceInit<CR>

au! BufWritePost $MYVIMRC source $MYVIMRC

" buffer switching
nnoremap <silent> <C-n> :bnext<CR>
nnoremap <silent> <C-p> :bprev<CR>
nnoremap <silent> <Leader>bn :bnext<CR>
nnoremap <silent> <Leader>bp :bprev<CR>

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
let g:which_key_timeout = 300
" let g:which_key_use_floating_win = 1 " need newer neovim
let g:which_key_fallback_to_native_key = 1
let g:which_key_run_map_on_popup = 1

nnoremap <silent> <Leader> :<C-u>WhichKey '<Space>'<CR>
nnoremap <silent> <LocalLeader> :<C-u>WhichKey ','<CR>

let g:which_key_map.b = { 'name': '+buffers' }
let g:which_key_map.i = { 'name': '+init.vim' }
let g:which_key_map.w = { 'name': '+windows' }
let g:which_key_map.w.h = 'left-window'
let g:which_key_map.w.j = 'bottom-window'
let g:which_key_map.w.k = 'top-window'
let g:which_key_map.w.l = 'right-window'

" fzf
nnoremap <silent> <Leader>ff :Files<CR>
nnoremap <silent> <Leader>fg :GitFiles<CR>
nnoremap <silent> <Leader>fb :Buffers<CR>

let g:which_key_map.f = { 'name': '+fzf' }

" easymotion
map <Leader><Leader>h <Plug>(easymotion-linebackward)
map <Leader><Leader>l <Plug>(easymotion-lineforward)

" OmniSharp
" let g:OmniSharp_server_stdio = 1

" fugitive
command! GitCheckoutBranch call fzf#run(fzf#wrap({ 'source': 'git branch | cut -c 3-', 'sink': 'G checkout' }))

nnoremap <silent> <Leader>gg :Git<CR>
nnoremap <silent> <Leader>gi :Git commit<CR>
nnoremap <silent> <Leader>go :GitCheckoutBranch<CR>
nnoremap <silent> <Leader>gl :Commits<CR>

let g:which_key_map.g = { 'name': '+git' }

