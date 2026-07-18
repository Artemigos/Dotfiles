vim.keymap.set('n', '<leader>x', ':!zig build run<CR>', { desc = 'Run current zig project in Debug' })
vim.keymap.set('n', '<leader>X', ':!zig build run --release=safe<CR>',
    { desc = 'Run current zig project in ReleaseSafe' })
