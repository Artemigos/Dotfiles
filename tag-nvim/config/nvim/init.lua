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

require('user.general')

-- NOTE: needs to be here - when doing restore from lockfile, it MUST live before the first `vim.pack.add`
-- the flow (an educated guess, based on what I can infer from docs and observations):
-- - init until first call to `add`
-- - restore from lockfile
-- - PackChanged (if configured in init before the first `add`) (if there were any changes due to lockfile content)
-- - process init to the end (on each `add`, the plugins become require-able, but don't "load" yet)
-- - PackChanged again if any of the init code results in an install/update
-- - load plugins (this is where commands get created usually)
-- TODO: utility to register those per plugin and execute here
-- TODO: this needs to be able to remember plugins installed during lockfile restore and run their steps after plugin load
-- TODO: the above is necesasry for first lockfile restore correctly running TSUpdate
vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local kind = ev.data.kind
        if kind == 'install' or kind == 'update' then
            local name = ev.data.spec.name
            if name == 'telescope-fzf-native.nvim' then
                vim.system({ 'make' }, { cwd = ev.data.path }):wait()
            elseif name == 'nvim-treesitter' then
                vim.api.nvim_create_autocmd('VimEnter', {
                    callback = function()
                        vim.cmd.TSUpdate()
                        return true
                    end,
                })
            end
        end
    end,
})

require('plugins.libraries')
require('plugins.completion')
-- require('plugins.debugging')
require('plugins.general')
require('plugins.llm')
require('plugins.lsp')
require('plugins.misc')
require('plugins.telescope')
require('plugins.treesitter')
require('plugins.ui')

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
