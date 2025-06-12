local function flag_condition(flag)
    return function()
        return require('user.localconf').get({ 'toggles', flag }, false)
    end
end

local copilot_condition = flag_condition('copilot')
local ollama_flag = flag_condition('ollama')

local function ollama_condition()
    if copilot_condition() then
        return false
    end
    return ollama_flag()
end

return {
    {
        'github/copilot.vim',
        cond = copilot_condition,
        event = 'VeryLazy',
        config = function()
            vim.g.copilot_filetypes = {
                text = false,
            }
            vim.g.copilot_no_tab_map = true
            vim.keymap.set('i', '<M-Enter>', 'copilot#Accept("\\<CR>")', {
                expr = true,
                replace_keycodes = false,
            })
        end,
    },

    {
        "CopilotC-Nvim/CopilotChat.nvim",
        cond = copilot_condition,
        event = 'VeryLazy',
        branch = 'main',
        dependencies = {
            { "github/copilot.vim" },
            { "nvim-lua/plenary.nvim" },
        },
        -- build = "make tiktoken",
        opts = {},
    },

    {
        'milanglacier/minuet-ai.nvim',
        cond = ollama_condition,
        event = 'VeryLazy',
        opts = {
            provider = 'openai_fim_compatible',
            n_completions = 1,
            context_window = 512,
            provider_options = {
                openai_fim_compatible = {
                    name = 'Ollama',
                    api_key = 'TERM',
                    end_point = 'http://127.0.0.1:11434/v1/completions',
                    model = 'qwen2.5-coder:3b',
                    optional = {
                        max_tokens = 256,
                        top_p = 0.9,
                    },
                },
            },
            virtualtext = {
                auto_trigger_ft = {},
                keymap = {
                    accept = '<M-Enter>',
                    accept_line = '<M-\\>',
                    prev = '<M-[>',
                    next = '<M-]>',
                },
            },
        },
    },
}
