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
    precedes = '❮',
    nbsp = '␣',
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
set.showmode = false
set.winborder = 'rounded'
vim.g.health = { style = 'float' }

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
set.timeoutlen = 360
vim.cmd('set diffopt+=inline:word') -- lua's Option:append doesn't remove existing inline:* options, but vimscript's += does

u.defcmd('W', 'w')

-- leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.hl.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- diagnostics
local signs = {
    [vim.diagnostic.severity.ERROR] = '',
    [vim.diagnostic.severity.WARN] = '',
    [vim.diagnostic.severity.INFO] = '',
    [vim.diagnostic.severity.HINT] = '',
}
local hl_map = {
    [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
    [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
    [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
    [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
}
vim.diagnostic.config({
    virtual_text = true,
    signs = {
        text = signs,
    },
    float = {
        scope = 'cursor',
        border = 'rounded',
    },
    update_in_insert = true,
    severity_sort = true,
    jump = {
        on_jump = function(_, _) vim.diagnostic.open_float() end,
    },
    status = {
        format = function(counts)
            local items = {}
            for level, _ in ipairs(vim.diagnostic.severity) do
                local count = counts[level] or 0
                if count > 0 then
                    table.insert(items, ("%%$%s$%s %s"):format(hl_map[level], signs[level], count))
                end
            end
            return table.concat(items, " ")
        end,
    }
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
vim.api.nvim_create_autocmd('Filetype', {
    pattern = require('user.tool-windows').get_filetypes(),
    callback = function()
        u.map('n', '<Esc>', ':close<CR>', { buffer = true, desc = 'Close window' })
    end,
})

-- mouse menu
vim.cmd [[
aunmenu PopUp
autocmd! nvim.popupmenu
anoremenu PopUp.Help\ I'm\ stuck <cmd>help :q<CR>
anoremenu PopUp.Quit <cmd>confirm qa<CR>
]]
