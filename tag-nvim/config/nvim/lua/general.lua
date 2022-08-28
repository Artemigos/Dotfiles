local fn = vim.fn
local cmd = vim.cmd
local set = vim.opt

-- colors
cmd [[
    syntax enable
    colorscheme dracula
]]
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
    tab = '→ ',
    extends = '❯',
    precedes = '❮'
}

-- editor appearance
set.relativenumber = true
set.number = true
set.cursorline = true
set.foldcolumn = 'auto:9'

-- quality of life
set.wildmenu = true
set.path:append('**')
vim.g.netrw_liststyle = 3
vim.g.netrw_list_hide = fn['netrw_gitignore#Hide']()
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

cmd [[command! W w]]

-- leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- treesitter
require('nvim-treesitter.configs').setup({
    auto_install = true,
    highlight = { enable = true },
})
