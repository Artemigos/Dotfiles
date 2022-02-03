require('nvim-tree').setup {
    view = {
        side = 'right',
        width = 45,
    }
}

nmap('<Leader>e', ':NvimTreeToggle<CR>')
