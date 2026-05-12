vim.pack.add({
    'https://github.com/Mofiqul/dracula.nvim',
    'https://github.com/folke/which-key.nvim',
})

local u = require('user.utils')

-- dracula.nvim
require('dracula').setup({
    overrides = function()
        return {
            NvimTreeNormal = { link = 'Normal' },
        }
    end,
})
vim.cmd [[
    syntax enable
    colorscheme dracula
]]

-- mini.icons
require('mini.icons').setup({})
MiniIcons.mock_nvim_web_devicons()

-- which-key.nvim (VeryLazy)
local wk = require('which-key')
wk.setup({})
wk.add({
    { "<Leader>b",   group = "buffers" },
    { "<Leader>c",   group = "code" },
    { "<Leader>d",   group = "debugging" },
    { "<Leader>dl",  group = "launch" },
    { "<Leader>f",   group = "find" },
    { "<Leader>g",   group = "git" },
    { "<Leader>i",   group = "init.lua" },
    { "<Leader>n",   group = "notes" },
    { "<Leader>o",   group = "open" },
    { "<Leader>p",   group = "peek" },
    { "<Leader>r",   group = "refactor" },
    { "<Leader>t",   group = "terminal" },
    { "<Leader>tc",  desc = "any command" },
    { "<Leader>tv",  group = "vertical split" },
    { "<Leader>tvb", desc = "terminal bash" },
    { "<Leader>tvc", desc = "any command" },
    { "<Leader>tvf", desc = "terminal fish" },
    { "<Leader>tvt", desc = "terminal" },
    { "<Leader>w",   group = "windows" },
    { "<Leader>wc",  desc = "close-window" },
    { "<Leader>wh",  desc = "left-window" },
    { "<Leader>wj",  desc = "bottom-window" },
    { "<Leader>wk",  desc = "top-window" },
    { "<Leader>wl",  desc = "right-window" },
    { "<Leader>x",   group = "tasks" },
})

-- mini.files
local show_dotfiles = true
local show_gitignored = true
local ls_files = u.cached(5000, u.try_exec,
    'git ls-files --cached --other --exclude-standard | xargs realpath')
local filter = function(fs_entry)
    if show_dotfiles and show_gitignored then
        return true
    end

    if not show_dotfiles and vim.startswith(fs_entry.name, '.') then
        return false
    end

    if show_gitignored then
        return true
    end

    local result = ls_files()
    if result == nil or result.code ~= 0 then
        return true
    end

    local lines = vim.split(result.output, '\n')
    for _, entry in ipairs(lines) do
        if vim.startswith(entry, fs_entry.path) then
            return true
        end
    end

    return false
end

local mf = require('mini.files')
mf.setup({
    content = {
        filter = filter,
    },
    mappings = {
        go_in_plus = '<CR>',
    },
    windows = {
        preview = true,
        width_preview = 40,
    },
})

local toggle_dotfiles = function()
    show_dotfiles = not show_dotfiles
    mf.refresh({ content = { filter = filter } })
end

local toggle_gitignored = function()
    show_gitignored = not show_gitignored
    mf.refresh({ content = { filter = filter } })
end

vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
        vim.keymap.set('n', 'Id', toggle_dotfiles, { buffer = args.data.buf_id })
        vim.keymap.set('n', 'Ig', toggle_gitignored, { buffer = args.data.buf_id })
    end,
})

vim.keymap.set(
    'n',
    '<Leader>e',
    function() if not mf.close() then mf.open() end end,
    { desc = 'Toggle file explorer' }
)

-- integrate with snacks.rename
vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesActionRename',
    callback = function(event)
        Snacks.rename.on_rename_file(event.data.from, event.data.to)
    end,
})

-- mini.bufremove
local mb = require('mini.bufremove')
mb.setup({})
vim.keymap.set('n', '<Leader>bd', function() require('mini.bufremove').delete(0, false) end, { desc = 'Delete buffer' })
vim.keymap.set('n', '<Leader>bD', function() require('mini.bufremove').delete(0, true) end,
    { desc = 'Delete buffer (force)' })
