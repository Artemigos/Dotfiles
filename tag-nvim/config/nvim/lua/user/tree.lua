local u = require('user.utils')

require('nvim-tree').setup {
    view = {
        side = 'right',
        width = 45,
    }
}

u.nmap('<Leader>e', ':NvimTreeToggle<CR>')

vim.api.nvim_create_autocmd('WinLeave', {
    pattern = 'NvimTree_1',
    command = 'close',
})
