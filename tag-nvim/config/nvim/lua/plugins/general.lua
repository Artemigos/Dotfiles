return {
    { 'tpope/vim-repeat',                event = 'VeryLazy' },
    {
        'ggandor/leap.nvim',
        config = function()
            local function leap(opts)
                return function()
                    require('leap').leap(opts or {})
                end
            end
            vim.keymap.set('n', 's', leap(), { desc = 'Leap motion' });
            vim.keymap.set('n', 'S', leap({ backward = true }), { desc = 'Backward leap motion' });
        end,
    },
    { 'tpope/vim-surround',              event = 'VeryLazy' },
    { 'wellle/targets.vim',              event = 'VeryLazy' },
    { 'airblade/vim-rooter',             enabled = false },
    { 'michaeljsmith/vim-indent-object', event = 'VeryLazy' },
    { 'tpope/vim-sleuth',                event = 'VeryLazy' },
    {
        'numToStr/Comment.nvim',
        opts = {},
        keys = {
            { 'gc', mode = { 'n', 'v' } },
            { 'gb', mode = { 'n', 'v' } },
        },
    },
}
