return {
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
    { 'nathom/filetype.nvim' },
}
