return {
    {
        'mfussenegger/nvim-dap',
        lazy = true,
        dependencies = {
            { 'rcarriga/nvim-dap-ui', opts = {} },
            { 'theHamsta/nvim-dap-virtual-text', opts = {} },
        },
        config = function()
            local dap = require('dap')
            local dapui = require('dapui')

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
        end,
        keys = {
            { '<F9>', '<cmd>lua require"dap".toggle_breakpoint()<CR>', desc = 'Toggle breakpoint' },
            { '<F5>', '<cmd>lua require"dap".continue()<CR>', desc = 'Continue' },
            { '<F10>', '<cmd>lua require"dap".step_over()<CR>', desc = 'Step over' },
            { '<F11>', '<cmd>lua require"dap".step_into()<CR>', desc = 'Step into' },

            { '<leader>do', '<cmd>lua require"dapui".toggle()<CR>', desc = 'Toggle UI' },
            { '<leader>db', '<cmd>lua require"dap".toggle_breakpoint()<CR>', desc = 'Toggle breakpoint' },
            { '<leader>dc', '<cmd>lua require"dap".continue()<CR>', desc = 'Continue' },
            { '<leader>dv', '<cmd>lua require"dap".step_over()<CR>', desc = 'Step over' },
            { '<leader>di', '<cmd>lua require"dap".step_into()<CR>', desc = 'Step into' },
        },
    },
}
