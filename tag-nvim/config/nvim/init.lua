local fn = vim.fn

-- bootstrap packer
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- install plugins
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim' -- to prevent packer from removing itself

    -- general
    use 'tpope/vim-repeat'
    use 'ggandor/lightspeed.nvim'
    use 'tpope/vim-surround'
    use 'wellle/targets.vim'
    use 'airblade/vim-rooter'
    use 'michaeljsmith/vim-indent-object'

    -- ui
    use {'dracula/vim', as='dracula'}
    use { 'kyazdani42/nvim-web-devicons', config = function() require('nvim-web-devicons').setup { default = true } end }
    use 'folke/which-key.nvim'
    use 'itchyny/lightline.vim'
    use 'akinsho/bufferline.nvim'
    use { 'kyazdani42/nvim-tree.lua', requires = { 'kyazdani42/nvim-web-devicons' }, config = function() require('tree') end }

    -- telescope
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'
    use {'nvim-telescope/telescope-fzf-native.nvim', run='make'}
    use 'nvim-telescope/telescope-file-browser.nvim'
    use 'stevearc/dressing.nvim'

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
    use { 'ray-x/lsp_signature.nvim', config = function() require('lsp_signature').setup {} end }
    use 'onsails/lspkind-nvim'
    use 'gbrlsnchs/telescope-lsp-handlers.nvim'

    -- misc
    use 'tpope/vim-fugitive'
    use 'tridactyl/vim-tridactyl'

    if PACKER_BOOTSTRAP then
        require('packer').sync()
    end
end)

-- include other config files
require('utils')
require('general')
require('lightline')
require('bufferline-conf')
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
