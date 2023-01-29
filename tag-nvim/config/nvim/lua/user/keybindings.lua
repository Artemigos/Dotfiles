local u = require('user.utils')

u.which_key_leader({
    b = {name='+buffers'},
    i = {name='+init.lua'},
    w = {
        name = '+windows',
        h = 'left-window',
        j = 'bottom-window',
        k = 'top-window',
        l = 'right-window',
        c = 'close-window',
    },
    t = {
        name = '+terminal',
        c = 'any command',
        v = {
            name = '+vertical split',
            c = 'any command',
            b = 'terminal bash',
            f = 'terminal fish',
            t = 'terminal',
        },
    },
    o = {name='+open'},
})

-- working with init.vim
u.defcmd('EditInit', 'e $MYVIMRC')
u.defcmd('SourceInit', 'source $MYVIMRC')
u.defcmd('EditAnyInit', 'lua require\'telescope.builtin\'.find_files{follow=true,cwd=\'$XDG_CONFIG_HOME/nvim/\'}')

u.map('n', '<Leader>ie', ':EditInit<CR>')
u.map('n', '<Leader>is', ':SourceInit<CR>')
u.map('n', '<Leader>ia', ':EditAnyInit<CR>')

-- buffer switching
u.map('n', '<TAB>', ':bnext<CR>')
u.map('n', '<S-TAB>', ':bprev<CR>')

u.map('n', '<Leader>bb', ':Telescope buffers<CR>')
u.map('n', '<Leader>bn', ':bnext<CR>')
u.map('n', '<Leader>bp', ':bprev<CR>')
u.map('n', '<Leader>bd', ':bdelete<CR>')
u.map('n', '<Leader>bD', ':bdelete!<CR>')

u.map('n', '<Leader><Leader>', '<C-^>')

-- terminal commands
u.map('n', '<Leader>tb', ':terminal bash<CR>')
u.map('n', '<Leader>tf', ':terminal fish<CR>')
u.map('n', '<Leader>tt', ':terminal<CR>')
u.map('n', '<Leader>tc', ':lua vim.ui.input({prompt = "Command"}, function(input) if input then vim.cmd("terminal "..input) end end)<CR>')

u.map('n', '<Leader>tvb', ':vsplit term://bash<CR>')
u.map('n', '<Leader>tvf', ':vsplit term://fish<CR>')
u.map('n', '<Leader>tvt', ':vsplit term://<CR>')
u.map('n', '<Leader>tvc', ':lua vim.ui.input({prompt = "Command"}, function(input) if input then vim.cmd("vsplit term://"..input) end end)<CR>')

-- split switching
u.map('n', '<C-h>', '<C-w>h')
u.map('n', '<C-j>', '<C-w>j')
u.map('n', '<C-k>', '<C-w>k')
u.map('n', '<C-l>', '<C-w>l')
u.map('n', '<C-q>', ':close<CR>')
u.map('n', '<Leader>wh', '<C-w>h')
u.map('n', '<Leader>wj', '<C-w>j')
u.map('n', '<Leader>wk', '<C-w>k')
u.map('n', '<Leader>wl', '<C-w>l')
u.map('n', '<Leader>wc', ':close<CR>')

-- split resizing
u.map('n', '<A-h>', ':vertical resize -2<CR>')
u.map('n', '<A-j>', ':resize +2<CR>')
u.map('n', '<A-k>', ':resize -2<CR>')
u.map('n', '<A-l>', ':vertical resize +2<CR>')

-- smarter indenting
u.map('v', '<', '<gv')
u.map('v', '>', '>gv')

-- other
u.map('n', '<Space><Backspace>', ':nohl<CR>')
u.map('i', 'jk', '<ESC>')
u.map('v', 'p', '"_dP') -- keep default register when substitute-putting in visual mode

-- text files
u.map('n', '<Leader>os', ':e ~/scratch.txt<CR>')
u.map('n', '<Leader>ot', ':e ~/todo.txt<CR>')
u.map('n', '<Leader>oi', ':EditAnyInit<CR>')

-- diagnostics
u.map('n', '[d', ':lua vim.diagnostic.goto_prev()<CR>')
u.map('n', ']d', ':lua vim.diagnostic.goto_next()<CR>')
u.map('n', 'gx', '<cmd>lua vim.diagnostic.open_float()<CR>')
u.map('n', '<Leader>cx', '<cmd>lua vim.diagnostic.open_float()<CR>')

-- insert symbols
u.defcmd('Symbols', 'lua require("user.symbols").choose()<CR>')
u.map('n', '<Leader>s', '<cmd>Symbols<CR>')
