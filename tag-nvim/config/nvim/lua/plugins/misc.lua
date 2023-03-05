return {
    {
        'tpope/vim-fugitive',
        config = function() require('user.fugitive') end,
    },
    { 'tridactyl/vim-tridactyl' },
    { 'gpanders/editorconfig.nvim' },

    {
        'stevearc/overseer.nvim',
        opts = {
            task_editor = {
                bindings = {
                    n = {
                        ['<Esc>'] = 'Cancel',
                    },
                },
            },
        },
        keys = {
            { '<leader>x<space>', '<cmd>OverseerToggle<CR>' },
            { '<leader>xx', '<cmd>OverseerRun<CR>' },
            { '<leader>xf', '<cmd>OverseerQuickAction open float<CR>' },
        },
    },

    -- perf
    { 'tweekmonster/startuptime.vim' },
    { 'nathom/filetype.nvim' },
}
