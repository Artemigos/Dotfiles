local u = require('utils')
local defcmd = u.defcmd
local nmap = u.nmap
local imap = u.imap
local vmap = u.vmap

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
defcmd('EditInit', 'e $MYVIMRC')
defcmd('SourceInit', 'source $MYVIMRC')
defcmd('EditAnyInit', 'lua require\'telescope.builtin\'.find_files{follow=true,cwd=\'$XDG_CONFIG_HOME/nvim/\'}')

nmap('<Leader>ie', ':EditInit<CR>')
nmap('<Leader>is', ':SourceInit<CR>')
nmap('<Leader>ia', ':EditAnyInit<CR>')

-- buffer switching
nmap('<TAB>', ':bnext<CR>')
nmap('<S-TAB>', ':bprev<CR>')

nmap('<Leader>bb', ':Telescope buffers<CR>')
nmap('<Leader>bn', ':bnext<CR>')
nmap('<Leader>bp', ':bprev<CR>')
nmap('<Leader>bd', ':bdelete<CR>')
nmap('<Leader>bD', ':bdelete!<CR>')

nmap('<Leader><Leader>', '<C-^>')

-- terminal commands
nmap('<Leader>tb', ':terminal bash<CR>')
nmap('<Leader>tf', ':terminal fish<CR>')
nmap('<Leader>tt', ':terminal<CR>')
nmap('<Leader>tc', ':lua vim.ui.input({prompt = "Command"}, function(input) if input then vim.cmd("terminal "..input) end end)<CR>')

nmap('<Leader>tvb', ':vsplit term://bash<CR>')
nmap('<Leader>tvf', ':vsplit term://fish<CR>')
nmap('<Leader>tvt', ':vsplit term://<CR>')
nmap('<Leader>tvc', ':lua vim.ui.input({prompt = "Command"}, function(input) if input then vim.cmd("vsplit term://"..input) end end)<CR>')

-- split switching
nmap('<C-h>', '<C-w>h')
nmap('<C-j>', '<C-w>j')
nmap('<C-k>', '<C-w>k')
nmap('<C-l>', '<C-w>l')
nmap('<Leader>wh', '<C-w>h')
nmap('<Leader>wj', '<C-w>j')
nmap('<Leader>wk', '<C-w>k')
nmap('<Leader>wl', '<C-w>l')
nmap('<Leader>wc', ':close<CR>')

-- split resizing
nmap('<A-h>', ':vertical resize -2<CR>')
nmap('<A-j>', ':resize +2<CR>')
nmap('<A-k>', ':resize -2<CR>')
nmap('<A-l>', ':vertical resize +2<CR>')

-- smarter indenting
vmap('<', '<gv')
vmap('>', '>gv')

-- other
nmap('<Space><Backspace>', ':nohl<CR>')
imap('jk', '<ESC>')
vmap('p', '"_dP') -- keep default register when substitute-putting in visual mode

-- text files
nmap('<Leader>os', ':e ~/scratch.txt<CR>')
nmap('<Leader>ot', ':e ~/todo.txt<CR>')
nmap('<Leader>oi', ':EditAnyInit<CR>')

-- diagnostics
nmap('[d', ':lua vim.diagnostic.goto_prev()<CR>')
nmap(']d', ':lua vim.diagnostic.goto_next()<CR>')
nmap('gx', '<cmd>lua vim.diagnostic.open_float()<CR>')
nmap('<Leader>cx', '<cmd>lua vim.diagnostic.open_float()<CR>')
