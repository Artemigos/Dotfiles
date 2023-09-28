local function refactorMap(modes, key, op)
    key = '<leader>r' .. key
    return { key, function() require('refactoring').refactor(op) end, mode = modes, desc = op  }
end

return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = function()
            require('nvim-treesitter.install').update({ with_sync = true })
        end,
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)
            vim.api.nvim_set_hl(0, 'TSPlaygroundFocus', { link = 'Search' })
        end,
        dependencies = {
            { 'nvim-treesitter/nvim-treesitter-textobjects' },
            { 'nvim-treesitter/playground' },
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
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                        ["aa"] = "@parameter.outer",
                        ["ia"] = "@parameter.inner",
                        ["ab"] = "@block.outer",
                        ["ib"] = "@block.inner",
                        ["a/"] = "@comment.outer",
                    },
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
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                        ["]c"] = "@class.outer",
                        ["]a"] = "@parameter.outer",
                    },
                    goto_next_end = {
                        ["]F"] = "@function.outer",
                        ["]C"] = "@class.outer",
                        ["]A"] = "@parameter.outer",
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[c"] = "@class.outer",
                        ["[a"] = "@parameter.outer",
                    },
                    goto_previous_end = {
                        ["[F"] = "@function.outer",
                        ["[C"] = "@class.outer",
                        ["[A"] = "@parameter.outer",
                    },
                },
                lsp_interop = {
                    enable = true,
                    border = 'single',
                    peek_definition_code = {
                        ["<leader>pf"] = "@function.outer",
                        ["<leader>pc"] = "@class.outer",
                    },
                },
            },
        }
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
            refactorMap({'n', 'x'}, 'i', 'Inline Variable'),
            refactorMap('n', 'b', 'Extract Block'),
            refactorMap('n', 'B', 'Extract Block To File'),
            { '<leader>r<space>', function() require('refactoring').select_refactor() end, mode = {'n', 'x'}, desc ='Select refactoring'  },
        },
    }
}
