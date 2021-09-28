" download plugin system
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" plugins
call plug#begin(stdpath('data') . '/plugged')

" general
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-surround',
Plug 'tpope/vim-repeat',
Plug 'liuchengxu/vim-which-key'
Plug 'easymotion/vim-easymotion'
Plug 'itchyny/lightline.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'airblade/vim-rooter'

" telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'ray-x/lsp_signature.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'onsails/lspkind-nvim'
Plug 'gbrlsnchs/telescope-lsp-handlers.nvim'

" misc
Plug 'tpope/vim-fugitive'
Plug 'tridactyl/vim-tridactyl'

call plug#end()

" config sections
source $XDG_CONFIG_HOME/nvim/general.vim
source $XDG_CONFIG_HOME/nvim/which-key.vim
source $XDG_CONFIG_HOME/nvim/keybindings.vim
source $XDG_CONFIG_HOME/nvim/telescope.vim
source $XDG_CONFIG_HOME/nvim/lsp.vim
source $XDG_CONFIG_HOME/nvim/easymotion.vim
source $XDG_CONFIG_HOME/nvim/fugitive.vim
source $XDG_CONFIG_HOME/nvim/lightline.vim
source $XDG_CONFIG_HOME/nvim/todo.vim
source $XDG_CONFIG_HOME/nvim/dotnet.vim
source $XDG_CONFIG_HOME/nvim/special-files.vim

