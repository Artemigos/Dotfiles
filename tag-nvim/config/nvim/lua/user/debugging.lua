local u = require('user.utils')

-- keybindings
u.map('n', '<F9>', '<cmd>lua require"dap".toggle_breakpoint()<CR>')
u.map('n', '<F5>', '<cmd>lua require"dap".continue()<CR>')
u.map('n', '<F10>', '<cmd>lua require"dap".step_over()<CR>')
u.map('n', '<F11>', '<cmd>lua require"dap".step_into()<CR>')

-- leader keybindings
u.which_key_leader({
    d = { name = '+debugging' },
})

u.map('n', '<leader>do', '<cmd>lua require"dapui".toggle()<CR>')
u.map('n', '<leader>db', '<cmd>lua require"dap".toggle_breakpoint()<CR>')
u.map('n', '<leader>dc', '<cmd>lua require"dap".continue()<CR>')
u.map('n', '<leader>dv', '<cmd>lua require"dap".step_over()<CR>')
u.map('n', '<leader>di', '<cmd>lua require"dap".step_into()<CR>')
u.map('n', '<leader>dll', '<cmd>lua require"osv".launch({port = 7182})<CR>')
u.map('n', '<leader>dls', '<cmd>lua require"osv".stop()<CR>')
u.map('n', '<leader>dlr', '<cmd>lua require"osv".run_this()<CR>')

-- UI
local dap = require('dap')
local dapui = require('dapui')
dapui.setup()
require('nvim-dap-virtual-text').setup({})

dap.listeners.after.event_initialized["dapui_config"] = function()
    ---@diagnostic disable-next-line: missing-parameter
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    ---@diagnostic disable-next-line: missing-parameter
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    ---@diagnostic disable-next-line: missing-parameter
    dapui.close()
end

-- lua
dap.configurations.lua = {
    {
        type = 'nlua',
        request = 'attach',
        name = "Attach to running Neovim instance",
        host = function()
            local value = vim.fn.input('Host [127.0.0.1]: ')
            if value ~= "" then
                return value
            end
            return '127.0.0.1'
        end,
        port = function()
            local value = vim.fn.input('Port [7182]: ')
            if value ~= "" then
                return tonumber(value)
            end
            return 7182
        end,
    }
}

dap.adapters.nlua = function(callback, config)
    callback({ type = 'server', host = config.host, port = config.port })
end
