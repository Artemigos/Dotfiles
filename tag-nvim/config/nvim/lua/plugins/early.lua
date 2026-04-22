vim.pack.add({
    'https://github.com/folke/snacks.nvim',
    {
        src = 'https://github.com/nvim-mini/mini.nvim',
        version = vim.version.range('*'),
    },
})


-- snack.nvim (priority = 1000)
require('snacks').setup({
    image = {},
    indent = {},
    input = {},
    picker = {},
    notifier = {},
    rename = {},
})

vim.keymap.set('n', '<Leader>ff', Snacks.picker.files, { desc = 'Find file' })
vim.keymap.set('n', '<Leader>fg', Snacks.picker.git_files, { desc = 'Find git file' })
vim.keymap.set('n', '<Leader>fb', Snacks.picker.buffers, { desc = 'Find buffer' })
vim.keymap.set('n', '<Leader>f/', Snacks.picker.grep, { desc = 'Live grep' })
vim.keymap.set('n', '<Leader>fc', Snacks.picker.commands, { desc = 'Find command' })
vim.keymap.set('n', '<Leader>fh', Snacks.picker.help, { desc = 'Find help' })
vim.keymap.set('n', '<Leader>f<Space>', Snacks.picker.pickers, { desc = 'Find picker' })
vim.keymap.set('n', '<Leader>fm', require("user.pickers").makefile, { desc = 'Run make target' })
vim.keymap.set('n', '<Leader>fr', Snacks.picker.resume, { desc = 'Resume last search' })
vim.keymap.set('n', '<Leader>fs', Snacks.picker.lsp_symbols, { desc = 'Find symbols in this file' })
