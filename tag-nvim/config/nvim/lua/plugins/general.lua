vim.pack.add({
    'https://github.com/tpope/vim-repeat',                -- VeryLazy
    'https://codeberg.org/andyg/leap.nvim',
    'https://github.com/tpope/vim-surround',              -- VeryLazy
    'https://github.com/wellle/targets.vim',              -- VeryLazy
    'https://github.com/michaeljsmith/vim-indent-object', -- VeryLazy
    'https://github.com/tpope/vim-sleuth',                -- VeryLazy
    'https://github.com/numToStr/Comment.nvim',
})

-- leap.nvim
local function leap(opts)
    return function()
        require('leap').leap(opts or {})
    end
end
vim.keymap.set('n', 's', leap(), { desc = 'Leap motion' });
vim.keymap.set('n', 'S', leap({ backward = true }), { desc = 'Backward leap motion' });

-- Comment.nvim
require('Comment').setup({})
