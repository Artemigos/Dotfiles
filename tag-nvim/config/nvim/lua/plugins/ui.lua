local u = require('user.utils')

local function format_mode(mode)
    local dash_pos = mode:find('-')
    if dash_pos ~= nil then
        return mode:sub(1, 1) .. mode:sub(dash_pos + 1, dash_pos + 1)
    end
    return mode:sub(1, 1)
end

local function window_title_extenstion()
    local tw = require('user.tool-windows')
    local txt = function() return tw.get_title(vim.o.filetype) end
    local winbar_opts = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
            { "'%='", separator = '' },
            { txt,    separator = '' },
            { "'%='", separator = '' },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    }

    local opts = {
        filetypes = tw.get_filetypes(),
        winbar = vim.deepcopy(winbar_opts),
        inactive_winbar = vim.deepcopy(winbar_opts),
        options = {
            always_divide_middle = false,
        }
    }

    return opts
end

local function get_schema()
    local schema = require("yaml-companion").get_buf_schema(0)
    if schema.result[1].name == "none" then
        return ""
    end
    return " " .. schema.result[1].name
end

local function is_yaml()
    return vim.bo.filetype == 'yaml'
end

local auto_format_component = {
    function() return '' end,
    color = function()
        if require('user.auto-format').is_auto_format_enabled(0) then
            return { fg = require('dracula').colors().green }
        else
            return { fg = require('dracula').colors().comment }
        end
    end,
    on_click = function() require('user.auto-format').toggle_auto_format(0) end,
}

return {
    {
        'Mofiqul/dracula.nvim',
        config = function(_, opts)
            require('dracula').setup(opts)
            vim.cmd [[
                syntax enable
                colorscheme dracula
            ]]
        end,
        opts = {
            overrides = function()
                return {
                    NvimTreeNormal = { link = 'Normal' },
                }
            end,
        },
    },

    {
        'kyazdani42/nvim-web-devicons',
        lazy = true,
        opts = { default = true },
    },

    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        config = function()
            local wk = require('which-key')
            wk.setup({})
            wk.add({
                { "<Leader>b",   group = "buffers" },
                { "<Leader>c",   group = "code" },
                { "<Leader>d",   group = "debugging" },
                { "<Leader>dl",  group = "launch" },
                { "<Leader>f",   group = "telescope" },
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
        end,
    },

    {
        'nvim-lualine/lualine.nvim',
        event = 'VeryLazy',
        dependencies = { 'kyazdani42/nvim-web-devicons' },
        opts = {
            options = {
                icons_enabled = true,
                theme = 'auto',
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {
                        'dap-repl',
                        'dapui_console',
                        'dapui_watches',
                        'dapui_stacks',
                        'dapui_breakpoints',
                        'dapui_scopes',
                        'gitcommit',
                    },
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = true,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                }
            },
            sections = {
                lualine_a = { { 'mode', fmt = format_mode } },
                lualine_b = { 'branch', 'diff', 'diagnostics' },
                lualine_c = { 'filename', { get_schema, cond = is_yaml } },
                lualine_x = { 'encoding', auto_format_component, 'fileformat', 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { 'filename' },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {}
            },
            --tabline = {
            --    lualine_a = {{'tabs'}},
            --    lualine_b = {},
            --    lualine_c = {},
            --    lualine_x = {},
            --    lualine_y = {},
            --    lualine_z = {}
            --},
            winbar = {
                lualine_a = { { 'buffers', symbols = { alternate_file = '' } } },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {}
            },
            inactive_winbar = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { 'filename' },
                lualine_x = {},
                lualine_y = {},
                lualine_z = {}
            },
            extensions = {
                'nvim-dap-ui',
                window_title_extenstion(),
            },
        },
        config = function(_, opts)
            require('lualine').setup(opts)
            vim.opt.showtabline = 1
        end,
    },

    {
        'echasnovski/mini.files',
        version = '*',
        opts = {
            mappings = {
                go_in_plus = '<CR>',
            },
            windows = {
                preview = true,
                width_preview = 40,
            },
        },
        config = function(_, opts)
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

            opts.content = { filter = filter }
            local mf = require('mini.files')
            mf.setup(opts)

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
        end,
        keys = {
            {
                '<Leader>e',
                function() if not require('mini.files').close() then require('mini.files').open() end end,
                desc = 'Toggle file explorer'
            },
        },
    },

    {
        'j-hui/fidget.nvim',
        branch = 'legacy',
        event = 'VeryLazy',
        opts = {},
    },

    {
        'lukas-reineke/indent-blankline.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        main = 'ibl',
        opts = {},
    },

    {
        'rcarriga/nvim-notify',
        event = 'VeryLazy',
        config = function()
            local n = require('notify')
            n.setup({ render = 'compact' })
            vim.notify = n
        end,
    },

    {
        'echasnovski/mini.bufremove',
        main = 'mini.bufremove',
        opts = {},
        keys = {
            { '<Leader>bd', function() require('mini.bufremove').delete(0, false) end, desc = 'Delete buffer' },
            { '<Leader>bD', function() require('mini.bufremove').delete(0, true) end,  desc = 'Delete buffer (force)' },
        },
    },
}
