local u = require('user.utils')
require('overseer').setup({
    task_editor = {
        bindings = {
            n = {
                ['<Esc>'] = 'Cancel',
            },
        },
    },
})

u.map('n', '<leader>x<space>', '<cmd>OverseerToggle<CR>')
u.map('n', '<leader>xx', '<cmd>OverseerRun<CR>')
u.map('n', '<leader>xf', '<cmd>OverseerQuickAction open float<CR>')
