local u = require('user.utils')

-- buffer switching
u.map('n', '<TAB>', ':bnext<CR>')
u.map('n', '<S-TAB>', ':bprev<CR>')

u.map('n', '<Leader>bb', ':Telescope buffers<CR>')
u.map('n', '<Leader>bn', ':bnext<CR>')
u.map('n', '<Leader>bp', ':bprev<CR>')

u.map('n', '<Leader><Leader>', '<C-^>')

-- terminal commands
u.map('n', '<Leader>tb', ':terminal bash<CR>')
u.map('n', '<Leader>tf', ':terminal fish<CR>')
u.map('n', '<Leader>tt', ':terminal<CR>')
u.map('n', '<Leader>tc', function()
    vim.ui.input(
        { prompt = "Command" },
        function(input)
            if input then
                vim.cmd("terminal " .. input)
            end
        end)
end)

u.map('n', '<Leader>tvb', ':vsplit term://bash<CR>')
u.map('n', '<Leader>tvf', ':vsplit term://fish<CR>')
u.map('n', '<Leader>tvt', ':vsplit term://<CR>')
u.map('n', '<Leader>tvc', function()
    vim.ui.input(
        { prompt = "Command" },
        function(input)
            if input then
                vim.cmd("vsplit term://" .. input)
            end
        end)
end)

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
-- disabled: breaks when selection is at the end of the line or at last line of the buffer
-- u.map('v', 'p', '"_dP') -- keep default register when substitute-putting in visual mode

-- text files
u.map('n', '<Leader>os', ':e ~/scratch.txt<CR>')
u.map('n', '<Leader>ot', ':e ~/todo.txt<CR>')
u.map('n', '<Leader>oi', ':EditAnyInit<CR>')

-- diagnostics
u.map('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = 'Go to previous diagnostic' })
u.map('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = 'Go to next diagnostic' })
u.map('n', '[e',
    function() vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR }) end,
    { desc = 'Go to previous error' })
u.map('n', ']e',
    function() vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR }) end,
    { desc = 'Go to next error' })
u.map('n', 'gx', vim.diagnostic.open_float, { desc = 'Open diagnostic float' })
u.map('n', '<Leader>cx', vim.diagnostic.open_float, { desc = 'Open diagnostic float' })

-- insert symbols
u.defcmd('Symbols', 'lua require("user.symbols").choose()<CR>')
u.map('n', '<Leader>s', '<cmd>Symbols<CR>')

-- create notes
u.map('n', '<Leader>nm', function() require('user.notes').ui_new_dated_note('!Work/Meetings') end,
    { desc = 'Create meeting note' })
u.map('n', '<Leader>nd', function() require('user.notes').create_dated_note('Daily', 'Daily') end,
    { desc = 'Create daily note' })
u.map('n', '<Leader>nt',
    function() require('user.notes').ui_new_note('Things', require('user.notes').find_link_text_under_cursor()) end,
    { desc = 'Create a note for a thing' })
