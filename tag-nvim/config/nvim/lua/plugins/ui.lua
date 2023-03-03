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
}
