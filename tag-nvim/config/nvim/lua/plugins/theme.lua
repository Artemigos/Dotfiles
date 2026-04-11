vim.pack.add({
    'https://github.com/Mofiqul/dracula.nvim',
})

-- dracula.nvim
require('dracula').setup({
    overrides = function()
        return {
            NvimTreeNormal = { link = 'Normal' },
        }
    end,
})
vim.cmd [[
    syntax enable
    colorscheme dracula
]]
