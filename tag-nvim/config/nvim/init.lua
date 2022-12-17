-- bootstrap packer
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    is_bootstrap = true
    vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
    vim.cmd [[packadd packer.nvim]]
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

    -- treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            pcall(require('nvim-treesitter.install').update({ with_sync = true }))
        end,
    }
    use { 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter' }

    -- ui
    use 'Mofiqul/dracula.nvim'
    use 'kyazdani42/nvim-web-devicons'
    use 'folke/which-key.nvim'
    use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
    use { 'akinsho/bufferline.nvim', tag = 'v2.*', requires = 'kyazdani42/nvim-web-devicons' }
    use { 'kyazdani42/nvim-tree.lua', requires = { 'kyazdani42/nvim-web-devicons' } }

    -- telescope
    use 'nvim-lua/plenary.nvim'
    use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }
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
    use {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',
    }
    use 'ray-x/lsp_signature.nvim'
    use 'onsails/lspkind-nvim'
    use 'gbrlsnchs/telescope-lsp-handlers.nvim'

    -- dap
    use 'mfussenegger/nvim-dap'
    use { 'rcarriga/nvim-dap-ui', requires = {'mfussenegger/nvim-dap'} }
    use { 'theHamsta/nvim-dap-virtual-text', requires = {'mfussenegger/nvim-dap', 'nvim-treesitter/nvim-treesitter'} }
    use 'jbyuki/one-small-step-for-vimkind'

    -- misc
    use 'tpope/vim-fugitive'
    use 'tridactyl/vim-tridactyl'
    use 'gpanders/editorconfig.nvim'

    -- perf
    use 'tweekmonster/startuptime.vim'
    use 'lewis6991/impatient.nvim'
    use 'nathom/filetype.nvim'

    if is_bootstrap then
        require('packer').sync()
    end
end)

if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

-- include other config files
require('impatient') -- this is a plugin require
require('utils')
require('general')
require('treesitter')
require('nvim-web-devicons').setup { default = true }
require('lualine-conf')
require('bufferline-conf')
require('tree')
require('which-key').setup{} -- this is a plugin require
require('keybindings')
require('telescope-conf')
require('fugitive')
require('cmp-conf')
require('lsp')
--require('dotnet')
require('debugging')
require('todo').setup{} -- this use from my config
require('special-files')
