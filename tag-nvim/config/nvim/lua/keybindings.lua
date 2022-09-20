which_key_leader({
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
        name = '+tabs',
        n = 'next-tab',
        p = 'previous-tab',
    },
    o = {name='+open'},
})

-- working with init.vim
vim.cmd [[
    command! EditInit e $MYVIMRC
    command! SourceInit source $MYVIMRC
    command! EditAnyInit :lua require'telescope.builtin'.find_files{follow=true,cwd='$XDG_CONFIG_HOME/nvim/'}<CR>
]]

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

nmap('<Leader><Leader>', '<C-^>')

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

-- tab navigation
nmap('<Leader>tn', 'gt')
nmap('<Leader>tp', 'gT')

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
