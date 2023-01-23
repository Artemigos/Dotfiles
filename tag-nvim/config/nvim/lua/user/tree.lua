local u = require('user.utils')

require('nvim-tree').setup {
    sync_root_with_cwd = true,
    view = {
        side = 'right',
        width = 45,
    },
    diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = false,
    },
}

u.nmap('<Leader>e', ':NvimTreeToggle<CR>')
