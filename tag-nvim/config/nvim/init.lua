local fn = vim.fn

-- bootstrap packer
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- install plugins
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim' -- to prevent packer from removing itself

    -- general
    use {'dracula/vim', as='dracula'}
    use 'folke/which-key.nvim'
    use 'tpope/vim-repeat'
    use 'ggandor/lightspeed.nvim'
    use 'tpope/vim-surround'
    use 'wellle/targets.vim'
    use 'itchyny/lightline.vim'
    use 'airblade/vim-rooter'
    use 'michaeljsmith/vim-indent-object'

    -- telescope
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'
    use {'nvim-telescope/telescope-fzf-native.nvim', run='make'}
    use 'nvim-telescope/telescope-file-browser.nvim'
    use 'nvim-telescope/telescope-ui-select.nvim'
    use 'kyazdani42/nvim-web-devicons'

    -- completion
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/vim-vsnip-integ'

    -- lsp
    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'
    use 'ray-x/lsp_signature.nvim'
    use 'kyazdani42/nvim-web-devicons'
    use 'onsails/lspkind-nvim'
    use 'gbrlsnchs/telescope-lsp-handlers.nvim'

    -- misc
    use 'tpope/vim-fugitive'
    use 'tridactyl/vim-tridactyl'

    if packer_bootstrap then
        require('packer').sync()
    end
end)

-- include other config files
require('utils')
require('general')
require('lightline')
require('which-key').setup{} -- this is a plugin require
require('keybindings')
require('telescope-conf')
require('fugitive')
require('cmp-conf')
require('lsp')
require('dotnet')
vim.cmd [[
    source $XDG_CONFIG_HOME/nvim/todo.vim
    source $XDG_CONFIG_HOME/nvim/special-files.vim
]]
