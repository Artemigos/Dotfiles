" download plugin system
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" plugins
call plug#begin(stdpath('data') . '/plugged')

Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-surround',
Plug 'tpope/vim-repeat',
Plug 'liuchengxu/vim-which-key'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-fugitive'
Plug 'itchyny/lightline.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'airblade/vim-rooter'

call plug#end()

" config sections
source $XDG_CONFIG_HOME/nvim/general.vim
source $XDG_CONFIG_HOME/nvim/which-key.vim
source $XDG_CONFIG_HOME/nvim/keybindings.vim
source $XDG_CONFIG_HOME/nvim/fzf.vim
" source $XDG_CONFIG_HOME/nvim/coc.vim
source $XDG_CONFIG_HOME/nvim/lsp.vim
source $XDG_CONFIG_HOME/nvim/easymotion.vim
source $XDG_CONFIG_HOME/nvim/fugitive.vim
source $XDG_CONFIG_HOME/nvim/lightline.vim
source $XDG_CONFIG_HOME/nvim/todo.vim
source $XDG_CONFIG_HOME/nvim/dotnet.vim

