require('overseer').setup({
    task_editor = {
        bindings = {
            n = {
                ['<Esc>'] = 'Cancel',
            },
        },
    },
})

vim.keymap.set('n', '<leader>x<space>', '<cmd>OverseerToggle<CR>', { silent = true })
vim.keymap.set('n', '<leader>xx', '<cmd>OverseerRun<CR>', { silent = true })
