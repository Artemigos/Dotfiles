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

local avante_provider = 'claude' -- default provider for avante.nvim
if copilot_condition() then
    avante_provider = 'copilot'
elseif ollama_condition() then
    avante_provider = 'ollama'
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
        -- TODO:
        -- - review highlights
        -- - copilot.lua instead of copilot.vim for work stuff
        -- - review the render-markdown optional dependency
        -- - review the img-clip dependency - I might actually want this for MD notes
        -- - consider bindings in mini.files to add files to context
        -- - do I even need the blink.cmp integration?
        'yetone/avante.nvim',
        build = 'make',
        event = 'VeryLazy',
        version = false,
        ---@module 'avante'
        ---@type avante.Config
        opts = {
            provider = avante_provider,
            -- auto_suggestions_provider = ollama_condition() and 'ollama' or nil,
            providers = {
                ollama = {
                    endpoint = 'http://127.0.0.1:11434',
                    model = 'qwen2.5-coder:3b',
                },
            },
            behaviour = {
                -- auto_suggestions = ollama_condition(),
                auto_approve_tool_permissions = false,
            },
            hints = { enabled = false },
            windows = {
                fillchars = vim.go.fillchars, -- ffs, respect my settings
                sidebar_header = {
                    enabled = true,           -- probably disable later
                },
                edit = {
                    start_insert = false,
                },
                ask = {
                    start_insert = false,
                },
            },
        },
        config = function(_, opts)
            require('avante').setup(opts)
            vim.api.nvim_set_hl(0, 'AvanteSidebarWinSeparator', { link = 'WinSeparator' }) -- ffs, respect my settings
        end,
        dependencies = {
            'nvim-lua/plenary.nvim',
            'MunifTanjim/nui.nvim',
            --- The below dependencies are optional,
            -- 'zbirenbaum/copilot.lua', -- for providers='copilot'
            -- {
            --     -- support for image pasting
            --     'HakonHarnes/img-clip.nvim',
            --     event = 'VeryLazy',
            --     opts = {
            --         -- recommended settings
            --         default = {
            --             embed_image_as_base64 = false,
            --             prompt_for_file_name = false,
            --             drag_and_drop = {
            --                 insert_mode = true,
            --             },
            --             -- required for Windows users
            --             use_absolute_path = true,
            --         },
            --     },
            -- },
            -- {
            --     -- Make sure to set this up properly if you have lazy=true
            --     'MeanderingProgrammer/render-markdown.nvim',
            --     opts = {
            --         file_types = { 'markdown', 'Avante' },
            --     },
            --     ft = { 'markdown', 'Avante' },
            -- },
        },
    },
}
