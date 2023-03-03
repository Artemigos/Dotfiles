return {
    -- general
    { 'tpope/vim-repeat' },
    { 'ggandor/lightspeed.nvim' },
    { 'tpope/vim-surround' },
    { 'wellle/targets.vim' },
    { 'airblade/vim-rooter' },
    { 'michaeljsmith/vim-indent-object' },
    { 'tpope/vim-sleuth' },

    -- treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = function()
            require('nvim-treesitter.install').update({ with_sync = true })
        end,
    },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    { 'nvim-treesitter/playground' },

    -- ui
    {
        'Mofiqul/dracula.nvim',
        config = function()
            vim.cmd [[
                syntax enable
                colorscheme dracula
            ]]
        end,
    },
    {
        'kyazdani42/nvim-web-devicons',
        config = function() require('nvim-web-devicons').setup { default = true } end,
    },
    {
        'folke/which-key.nvim',
        config = function() require('which-key').setup {} end,
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'kyazdani42/nvim-web-devicons' },
        config = function() require('user.lualine') end,
    },
    {
        'kyazdani42/nvim-tree.lua',
        dependencies = { 'kyazdani42/nvim-web-devicons' },
        config = function() require('user.tree') end,
    },
    {
        'j-hui/fidget.nvim',
        config = function() require('fidget').setup() end,
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require('indent_blankline').setup({
                space_char_blankline = ' ',
                show_current_context = true,
            })
        end,
    },
    {
        'rcarriga/nvim-notify',
        config = function()
            local n = require('notify')
            n.setup({ render = 'compact' })
            vim.notify = n
        end,
    },
    {
        'echasnovski/mini.bufremove',
        config = function() require('mini.bufremove').setup({}) end,
    },

    -- telescope
    { 'nvim-lua/plenary.nvim' },
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function() require('user.telescope') end,
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        dependencies = { 'nvim-telescope/telescope.nvim' },
        config = function() require('telescope').load_extension('fzf') end,
    },
    {
        'nvim-telescope/telescope-file-browser.nvim',
        config = function() require('telescope').load_extension('file_browser') end,
    },
    { 'stevearc/dressing.nvim' },

    -- completion
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-vsnip' },
    { 'hrsh7th/vim-vsnip' },
    { 'hrsh7th/vim-vsnip-integ' },

    -- lsp
    {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',
    },
    { 'ray-x/lsp_signature.nvim' },
    { 'onsails/lspkind-nvim' },
    {
        'gbrlsnchs/telescope-lsp-handlers.nvim',
        config = function() require('telescope').load_extension('lsp_handlers') end,
    },
    {
        "someone-stole-my-name/yaml-companion.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("telescope").load_extension("yaml_schema")
        end,
    },

    -- null-ls
    { 'jose-elias-alvarez/null-ls.nvim' },
    {
        'jayp0521/mason-null-ls.nvim',
        config = function() require('user.null-ls') end
    },

    -- dap
    { 'mfussenegger/nvim-dap' },
    { 'rcarriga/nvim-dap-ui', dependencies = { 'mfussenegger/nvim-dap' } },
    { 'theHamsta/nvim-dap-virtual-text', dependencies = { 'mfussenegger/nvim-dap', 'nvim-treesitter/nvim-treesitter' } },
    { 'jbyuki/one-small-step-for-vimkind' },

    -- markdown editing
    { 'mickael-menu/zk-nvim', config = function() require('zk').setup({
        picker = 'telescope',
    }) end },

    -- misc
    {
        'tpope/vim-fugitive',
        config = function() require('user.fugitive') end,
    },
    { 'tridactyl/vim-tridactyl' },
    { 'gpanders/editorconfig.nvim' },
    {
        'stevearc/overseer.nvim',
        config = function() require('user.overseer') end
    },

    -- perf
    { 'tweekmonster/startuptime.vim' },
    { 'lewis6991/impatient.nvim' },
    { 'nathom/filetype.nvim' },
}
