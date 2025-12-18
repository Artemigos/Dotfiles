require('user.general')

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

-- include other config files
require('user.keybindings')
require('user.todo').setup({})
require('user.md2jira').setup()
require('user.auto-format').setup({ filetypes = { 'rust', 'go', 'lua', 'zig' } })

-- override navigation if in TMUX
if vim.fn.empty(vim.env['TMUX']) == 0 then
    require('user.tmux-nav').setup()
end

-- filetypes
vim.filetype.add({
    extension = {
        vcl = 'vcl',
        vtc = 'vtc',
        alloy = 'alloy',
        tf = 'terraform',
    },
    filename = {
        Caddyfile = 'caddy',
    },
})
