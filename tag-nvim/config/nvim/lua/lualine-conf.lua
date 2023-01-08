local function format_mode(mode)
    local dash_pos = mode:find('-')
    if dash_pos ~= nil then
        return mode:sub(1, 1) .. mode:sub(dash_pos+1, dash_pos+1)
    end
    return mode:sub(1, 1)
end

local function window_title_extenstion(title, filetypes)
    local txt = function() return title end
    local winbar_opts = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
            {"'%='", separator = ''},
            {txt, separator = ''},
            {"'%='", separator = ''},
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    }

    local opts = {
        filetypes =  filetypes,
        winbar = vim.deepcopy(winbar_opts),
        inactive_winbar = vim.deepcopy(winbar_opts),
        options = {
            always_divide_middle = false,
        }
    }

    return opts
end

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
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
        lualine_a = {{ 'mode', fmt=format_mode }},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {
        lualine_a = {{'buffers', symbols = {alternate_file = ''}}},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    inactive_winbar = {
        lualine_a = {'filename'},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    extensions = {
        'nvim-dap-ui',
        window_title_extenstion('Git', {'fugitive'}),
        window_title_extenstion('File tree', {'NvimTree'}),
    },
}
