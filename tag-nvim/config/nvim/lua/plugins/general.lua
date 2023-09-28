return {
    { 'tpope/vim-repeat', event = 'VeryLazy' },
    { 'ggandor/lightspeed.nvim', event = 'VeryLazy' },
    { 'tpope/vim-surround', event = 'VeryLazy' },
    { 'wellle/targets.vim', event = 'VeryLazy' },
    { 'airblade/vim-rooter', enabled = false },
    { 'michaeljsmith/vim-indent-object', event = 'VeryLazy' },
    { 'tpope/vim-sleuth', event = 'VeryLazy' },
    {
        'numToStr/Comment.nvim',
        opts = {},
        keys = {
            { 'gc', mode = { 'n', 'v' } },
            { 'gb', mode = { 'n', 'v' } },
        },
    },
}
