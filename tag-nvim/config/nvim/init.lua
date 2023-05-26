require('user.general')

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- install plugins
require('lazy').setup('plugins', { ui = { border = 'rounded' } })

-- automatically format some code
local format_group = vim.api.nvim_create_augroup('AutoFormat', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
    command = 'Format',
    group = format_group,
    pattern = { '*.rs', '*.go' },
})

-- include other config files
require('user.keybindings')
require('user.todo').setup({})

-- override navigation if in TMUX
if vim.fn.empty(vim.env['TMUX']) == 0 then
    require('user.tmux-nav').setup()
end
