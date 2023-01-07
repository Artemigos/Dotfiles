local u = require('utils')

require('bufferline').setup {
    options = {
        show_buffer_close_icons = false,
        diagnostics = 'nvim_lsp'
    }
}

u.nmap('<Leader>b<Space>', ':BufferLinePick<CR>')
