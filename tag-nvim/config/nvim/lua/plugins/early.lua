vim.pack.add({
    'https://github.com/folke/snacks.nvim',
    {
        src = 'https://github.com/nvim-mini/mini.nvim',
        version = vim.version.range('*'),
    },
})

local u = require('user.utils')

-- snack.nvim (priority = 1000)
require('snacks').setup({
    image = {},
    indent = {},
    input = {},
    picker = {},
    notifier = {},
    rename = {},
})

vim.keymap.set('n', '<Leader>ff', u.lazy_pick.files, { desc = 'Find file' })
vim.keymap.set('n', '<Leader>fg', u.lazy_pick.git_files, { desc = 'Find git file' })
vim.keymap.set('n', '<Leader>fb', u.lazy_pick.buffers, { desc = 'Find buffer' })
vim.keymap.set('n', '<Leader>f/', u.lazy_pick.grep, { desc = 'Live grep' })
vim.keymap.set('n', '<Leader>fc', u.lazy_pick.commands, { desc = 'Find command' })
vim.keymap.set('n', '<Leader>fh', u.lazy_pick.help, { desc = 'Find help' })
vim.keymap.set('n', '<Leader>f<Space>', u.lazy_pick.pickers, { desc = 'Find picker' })
vim.keymap.set('n', '<Leader>fm', require("user.pickers").makefile, { desc = 'Run make target' })
vim.keymap.set('n', '<Leader>fr', u.lazy_pick.resume, { desc = 'Resume last search' })
vim.keymap.set('n', '<Leader>fs', u.lazy_pick.lsp_symbols, { desc = 'Find symbols in this file' })

-- lsp progress notifications, straight from help examples

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
    ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local value = ev.data.params
            .value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
        if not client or type(value) ~= "table" then
            return
        end
        local p = progress[client.id]

        for i = 1, #p + 1 do
            if i == #p + 1 or p[i].token == ev.data.params.token then
                p[i] = {
                    token = ev.data.params.token,
                    msg = ("[%3d%%] %s%s"):format(
                        value.kind == "end" and 100 or value.percentage or 100,
                        value.title or "",
                        value.message and (" **%s**"):format(value.message) or ""
                    ),
                    done = value.kind == "end",
                }
                break
            end
        end

        local msg = {} ---@type string[]
        progress[client.id] = vim.tbl_filter(function(v)
            return table.insert(msg, v.msg) or not v.done
        end, p)

        local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
        vim.notify(table.concat(msg, "\n"), "info", {
            id = "lsp_progress",
            title = client.name,
            opts = function(notif)
                notif.icon = #progress[client.id] == 0 and " "
                    or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
        })
    end,
})
