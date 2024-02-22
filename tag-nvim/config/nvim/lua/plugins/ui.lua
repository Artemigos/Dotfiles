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
            wk.register({
                b = { name = '+buffers' },
                c = { name = '+code' },
                d = { name = '+debugging', l = { name = '+launch' } },
                f = { name = '+telescope' },
                g = { name = '+git' },
                i = { name = '+init.lua' },
                n = { name = '+notes' },
                o = { name = '+open' },
                p = { name = '+peek' },
                r = { name = '+refactor' },
                t = {
                    name = '+terminal',
                    c = 'any command',
                    v = {
                        name = '+vertical split',
                        c = 'any command',
                        b = 'terminal bash',
                        f = 'terminal fish',
                        t = 'terminal',
                    },
                },
                w = {
                    name = '+windows',
                    h = 'left-window',
                    j = 'bottom-window',
                    k = 'top-window',
                    l = 'right-window',
                    c = 'close-window',
                },
                x = { name = '+tasks' },
            }, { prefix = '<Leader>' })
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
        'kyazdani42/nvim-tree.lua',
        enabled = false,
        dependencies = { 'kyazdani42/nvim-web-devicons' },
        cmd = 'NvimTreeToggle',
        opts = {
            sync_root_with_cwd = true,
            view = {
                side = 'right',
                width = 45,
            },
            diagnostics = {
                enable = true,
                show_on_dirs = true,
                show_on_open_dirs = false,
            },
        },
        keys = {
            { '<Leader>e', function() require('nvim-tree.api').tree.toggle() end, desc = 'Toggle file tree' },
        },
    },

    {
        'echasnovski/mini.files',
        version = '*',
        opts = {
            windows = {
                preview = true,
            },
        },
        config = function(_, opts)
            require('mini.files').setup(opts)
            local show_dotfiles = true

            local filter_show = function(_) return true end
            local filter_hide = function(fs_entry)
                return not vim.startswith(fs_entry.name, '.')
            end

            local toggle_dotfiles = function()
                show_dotfiles = not show_dotfiles
                local new_filter = show_dotfiles and filter_show or filter_hide
                MiniFiles.refresh({ content = { filter = new_filter } })
            end

            vim.api.nvim_create_autocmd('User', {
                pattern = 'MiniFilesBufferCreate',
                callback = function(args)
                    vim.keymap.set('n', 'I', toggle_dotfiles, { buffer = args.data.buf_id })
                end,
            })
        end,
        keys = {
            { '<Leader>e', function() if not MiniFiles.close() then MiniFiles.open() end end, desc = 'Toggle file explorer' },
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
        opts = {
            space_char_blankline = ' ',
            show_current_context = true,
        },
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
