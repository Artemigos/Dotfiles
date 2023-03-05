return {
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
        lazy = true,
        opts = { default = true },
    },

    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        config = function()
            local wk = require('which-key')
            wk.setup({})
            wk.register({
                c = { name = '+code' },
                d = { name = '+debugging', l = { name = '+launch' } },
                f = { name = '+telescope' },
                g = { name = '+git' },
                p = { name = '+peek' },
                r = { name = '+refactor' }
            }, { prefix = '<Leader>' })
        end,
    },

    {
        'nvim-lualine/lualine.nvim',
        event = 'VeryLazy',
        dependencies = { 'kyazdani42/nvim-web-devicons' },
        config = function() require('user.lualine') end,
    },

    {
        'kyazdani42/nvim-tree.lua',
        dependencies = { 'kyazdani42/nvim-web-devicons' },
        cmd = 'NvimTreeToggle',
        opts = {
            sync_root_with_cwd = true,
            view = {
                side = 'right',
                width = 45,
            },
            diagnostics = {
                enable = true,
                show_on_dirs = true,
                show_on_open_dirs = false,
            },
        },
        keys = {
            { '<Leader>e', function() require('nvim-tree.api').tree.toggle() end, desc = 'Toggle file tree' },
        },
    },

    {
        'j-hui/fidget.nvim',
        event = 'VeryLazy',
        opts = {},
    },

    {
        'lukas-reineke/indent-blankline.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        opts = {
            space_char_blankline = ' ',
            show_current_context = true,
        },
    },

    {
        'rcarriga/nvim-notify',
        event = 'VeryLazy',
        config = function()
            local n = require('notify')
            n.setup({ render = 'compact' })
            vim.notify = n
        end,
    },

    {
        'echasnovski/mini.bufremove',
        config = function() require('mini.bufremove').setup({}) end,
        keys = {
            { '<Leader>bd', function() require('mini.bufremove').delete(0, false) end, desc = 'Delete buffer' },
            { '<Leader>bD', function() require('mini.bufremove').delete(0, true) end, desc = 'Delete buffer (force)' },
        },
    },
}
