vim.pack.add({
    'https://github.com/folke/snacks.nvim',
    {
        src = 'https://github.com/nvim-mini/mini.nvim',
        version = vim.version.range('*'),
    },
})

local u = require('user.utils')

-- snack.nvim (priority = 1000)
require('snacks').setup({
    image = {},
    indent = {},
    input = {},
    picker = {},
    notifier = {},
    rename = {},
})

vim.keymap.set('n', '<Leader>ff', u.lazy_pick.files, { desc = 'Find file' })
vim.keymap.set('n', '<Leader>fg', u.lazy_pick.git_files, { desc = 'Find git file' })
vim.keymap.set('n', '<Leader>fb', u.lazy_pick.buffers, { desc = 'Find buffer' })
vim.keymap.set('n', '<Leader>f/', u.lazy_pick.grep, { desc = 'Live grep' })
vim.keymap.set('n', '<Leader>fc', u.lazy_pick.commands, { desc = 'Find command' })
vim.keymap.set('n', '<Leader>fh', u.lazy_pick.help, { desc = 'Find help' })
vim.keymap.set('n', '<Leader>f<Space>', u.lazy_pick.pickers, { desc = 'Find picker' })
vim.keymap.set('n', '<Leader>fm', require("user.pickers").makefile, { desc = 'Run make target' })
vim.keymap.set('n', '<Leader>fr', u.lazy_pick.resume, { desc = 'Resume last search' })
vim.keymap.set('n', '<Leader>fs', u.lazy_pick.lsp_symbols, { desc = 'Find symbols in this file' })
