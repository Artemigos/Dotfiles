if vim.env.PROF then
    local snacks = vim.fn.stdpath("data") .. "/site/pack/core/opt/snacks.nvim"
    vim.opt.rtp:append(snacks)
    require("snacks.profiler").startup({
        startup = {
            -- stop profiler on this event. Defaults to `VimEnter`
            event = "VimEnter",
            -- event = "UIEnter",
        },
    })
end

require('vim._core.ui2').enable({})

require('user.general')

-- NOTE: needs to be here - when doing restore from lockfile, it MUST live before the first `vim.pack.add`
-- the flow (an educated guess, based on what I can infer from docs and observations):
-- - init until first call to `add`
-- - restore from lockfile
-- - PackChanged (if configured in init before the first `add`) (if there were any changes due to lockfile content)
-- - process init to the end (on each `add`, the plugins become require-able, but don't "load" yet)
-- - PackChanged again if any of the init code results in an install/update
-- - load plugins (this is where commands get created usually)
local upack = require('user.pack')
upack.setup()
upack.register_post_load_build_step('nvim-treesitter', upack.vim_cmd_step('TSUpdate'))

require('plugins.early')
require('plugins.completion')
-- require('plugins.debugging')
require('plugins.general')
require('plugins.llm')
require('plugins.lsp')
require('plugins.misc')

-- delay loading some plugins
vim.api.nvim_create_autocmd('UIEnter', {
    callback = function()
        require('plugins.treesitter')
        require('plugins.ui')
        vim.cmd.packadd('nvim.undotree')
        return true
    end,
})

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
