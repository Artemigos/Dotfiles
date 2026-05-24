vim.pack.add({
    'https://github.com/tpope/vim-repeat',
    'https://codeberg.org/andyg/leap.nvim',
    'https://github.com/wellle/targets.vim',
    'https://github.com/tpope/vim-sleuth',
})

-- leap.nvim
local function leap(opts)
    return function()
        require('leap').leap(opts or {})
    end
end
vim.keymap.set('n', '<CR>', leap(), { desc = 'Leap motion' });
vim.keymap.set('n', '<M-CR>', leap({ backward = true }), { desc = 'Backward leap motion' });

-- mini.indentscope
require('mini.indentscope').setup({
    options = {
        indent_at_cursor = false,
    },
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    callback = function()
        vim.b.miniindentscope_config = {
            options = {
                border = 'top',
            },
        }
    end,
})

-- mini.surround
require('mini.surround').setup()
