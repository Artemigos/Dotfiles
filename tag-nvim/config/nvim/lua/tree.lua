local u = require('utils')

require('nvim-tree').setup {
    view = {
        side = 'right',
        width = 45,
    }
}

u.nmap('<Leader>e', ':NvimTreeToggle<CR>')
