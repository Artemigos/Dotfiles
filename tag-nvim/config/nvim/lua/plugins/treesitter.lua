local function refactorMap(modes, key, op)
    key = '<leader>r' .. key
    return { key, function() require('refactoring').refactor(op) end, mode = modes, desc = op }
end

local function textobjectSelectMap(key, query)
    vim.keymap.set(
        { 'x', 'o' },
        key,
        function()
            require('nvim-treesitter-textobjects.select').select_textobject(query)
        end,
        { desc = query }
    )
end

local function textobjectSwapMap(key, query, direction)
    vim.keymap.set(
        'n',
        key,
        function()
            require('nvim-treesitter-textobjects.swap')['swap_' .. direction](query)
        end,
        { desc = query }
    )
end

local function textobjectMoveMap(key, query, direction)
    vim.keymap.set(
        { 'n', 'x', 'o' },
        key,
        function()
            require('nvim-treesitter-textobjects.move')['goto_' .. direction](query)
        end,
        { desc = query }
    )
end

local function registerExtraGrammars()
    local cfg = require('nvim-treesitter.parsers').get_parser_configs()
    for _, lang in pairs({ 'vcl', 'vtc' }) do
        cfg[lang] = {
            install_info = {
                url = 'https://github.com/M4R7iNP/varnishls',
                branch = 'main',
                location = 'vendor/tree-sitter-' .. lang,
                files = { 'src/parser.c' },
                requires_generate_from_grammar = true,
            }
        }
    end
    cfg.alloy = {
        install_info = {
            url = 'https://github.com/Artemigos/tree-sitter-alloy',
            branch = 'main',
            files = { 'src/parser.c' },
        }
    }
end

return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = function()
            require('nvim-treesitter.install').update({ with_sync = true })
        end,
        config = function(_, opts)
            registerExtraGrammars()
            require('nvim-treesitter.configs').setup(opts)
            vim.api.nvim_set_hl(0, 'TSPlaygroundFocus', { link = 'Search' })

            textobjectSelectMap("af", "@function.outer")
            textobjectSelectMap("if", "@function.inner")
            textobjectSelectMap("ac", "@class.outer")
            textobjectSelectMap("ic", "@class.inner")
            textobjectSelectMap("aa", "@parameter.outer")
            textobjectSelectMap("ia", "@parameter.inner")
            textobjectSelectMap("ab", "@block.outer")
            textobjectSelectMap("ib", "@block.inner")
            textobjectSelectMap("a/", "@comment.outer")

            textobjectSwapMap("<leader>>a", "@parameter.inner", "next")
            textobjectSwapMap("<leader><a", "@parameter.inner", "previous")

            textobjectSwapMap("<leader>>f", "@function.outer", "next")
            textobjectSwapMap("<leader><f", "@function.outer", "previous")

            textobjectSwapMap("<leader>>c", "@class.outer", "next")
            textobjectSwapMap("<leader><c", "@class.outer", "previous")

            textobjectMoveMap("]f", "@function.outer", 'next_start')
            textobjectMoveMap("]c", "@class.outer", 'next_start')
            textobjectMoveMap("]a", "@parameter.outer", 'next_start')

            textobjectMoveMap("]F", "@function.outer", 'next_end')
            textobjectMoveMap("]C", "@class.outer", 'next_end')
            textobjectMoveMap("]A", "@parameter.outer", 'next_end')

            textobjectMoveMap("[f", "@function.outer", 'previous_start')
            textobjectMoveMap("[c", "@class.outer", 'previous_start')
            textobjectMoveMap("[a", "@parameter.outer", 'previous_start')

            textobjectMoveMap("[F", "@function.outer", 'previous_end')
            textobjectMoveMap("[C", "@class.outer", 'previous_end')
            textobjectMoveMap("[A", "@parameter.outer", 'previous_end')
        end,
        dependencies = {
            { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
        },
        event = { 'BufReadPost', 'BufNewFile' },
        opts = {
            auto_install = true,
            highlight = { enable = true },
            playground = { enable = true },
            ensure_installed = {
                'bash',
                'comment',
                'vimdoc',
                'json',
                'lua',
                'make',
                'markdown',
                'markdown_inline',
                'python',
                'query',
                'regex',
                'rust',
                'typescript',
                'vim',
                'yaml',
                'zig',
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<c-up>',
                    node_incremental = '<c-up>',
                    node_decremental = '<c-down>',
                },
            },
            textobjects = {
                select = {
                    lookahead = true,
                    selection_modes = {
                        ['@function.inner'] = 'V',
                        ['@function.outer'] = 'V',
                        ['@class.inner'] = 'V',
                        ['@class.outer'] = 'V',
                        ['@parameter.inner'] = 'v',
                        ['@parameter.outer'] = 'v',
                        ['@block.inner'] = 'V',
                        ['@block.outer'] = 'V',
                        ['@comment.outer'] = 'v',
                    },
                    include_surrounding_whitespace = true,
                },
                move = {
                    set_jumps = true,
                },
                -- NOTE: the feature is gone?
                -- lsp_interop = {
                --     enable = true,
                --     border = 'single',
                --     peek_definition_code = {
                --         ["<leader>pf"] = "@function.outer",
                --         ["<leader>pc"] = "@class.outer",
                --     },
                -- },
            },
        },
    },
    {
        'folke/todo-comments.nvim',
        cmd = {
            'TodoLocList',
            'TodoQuickFix',
            'TodoTrouble',
            'TodoTelescope',
        },
        event = { 'BufReadPost', 'BufNewFile' },
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        opts = {},
        keys = {
            { '<Leader>fT', '<cmd>TodoTelescope<CR>' },
        },
    },
    {
        'ThePrimeagen/refactoring.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
        },
        opts = {},
        cmd = {
            'Refactor',
        },
        keys = {
            refactorMap('x', 'e', 'Extract Function'),
            refactorMap('x', 'E', 'Extract Function To File'),
            refactorMap('x', 'v', 'Extract Variable'),
            refactorMap({ 'n', 'x' }, 'i', 'Inline Variable'),
            refactorMap('n', 'b', 'Extract Block'),
            refactorMap('n', 'B', 'Extract Block To File'),
            { '<leader>r<space>', function() require('refactoring').select_refactor() end, mode = { 'n', 'x' }, desc = 'Select refactoring' },
        },
    }
}
