local u = require('user.utils')
local set = vim.opt

-- colors
set.termguicolors = true

-- indenting settings
set.modeline = true -- read indent settings from within files
set.autoindent = true
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
set.expandtab = true
set.smarttab = true

-- non-printable characters
set.list = true
set.listchars = {
    trail = '⋅',
    lead = '⋅',
    tab = '→ ',
    extends = '❯',
    precedes = '❮'
}

-- editor appearance
set.relativenumber = true
set.number = true
set.cursorline = true
set.foldcolumn = 'auto:9'
set.breakindent = true
set.signcolumn = 'yes'
set.cmdheight = 2
set.fillchars:append {
    vert = '█',
    vertleft = '█',
    vertright = '█',
    horiz = '█',
    horizup = '█',
    horizdown = '█',
    verthoriz = '█',
}

-- quality of life
set.wildmenu = true
set.path:append('**')
vim.g.netrw_liststyle = 3
set.incsearch = true
set.scrolloff = 5
set.sidescrolloff = 5
set.formatoptions:append('j') -- delete comment character when joining commented lines
set.autoread = true
set.laststatus = 3
set.splitright = true
set.splitbelow = true
set.swapfile = false
set.mouse = 'nv'
set.shell = '/bin/bash' -- unification and perf improvement (fish makes things slow)
set.undofile = true
set.ignorecase = true
set.smartcase = true
set.updatetime = 250
set.completeopt = { 'menuone', 'noinsert', 'noselect' }
set.shortmess = 'filnxtToOFc'

u.defcmd('W', 'w')

-- leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- terminal window setup
local term_setup_group = vim.api.nvim_create_augroup('term_setup', { clear = true })
vim.api.nvim_create_autocmd({ 'TermOpen' }, {
    group = term_setup_group,
    pattern = '*',
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = 'no'
    end,
})

-- close some windows on <Esc>
vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*',
    callback = function()
        if vim.o.filetype == 'fugitive' or vim.o.filetype == 'NvimTree' then
            vim.keymap.set('n', '<Esc>', ':close<CR>', { silent = true, buffer = true, desc = 'Close window' })
        end
    end,
})
