require('bufferline').setup {
    options = {
        show_buffer_close_icons = false,
        diagnostics = 'nvim_lsp'
    }
}

nmap('<Leader>b<Space>', ':BufferLinePick<CR>')
