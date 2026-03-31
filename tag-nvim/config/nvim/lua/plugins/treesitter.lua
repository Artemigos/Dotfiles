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

-- register extra parsers
vim.api.nvim_create_autocmd('User', {
    pattern = 'TSUpdate',
    callback = function()
        local cfg = require('nvim-treesitter.parsers')
        for _, lang in pairs({ 'vcl', 'vtc' }) do
            cfg[lang] = {
                install_info = {
                    url = 'https://github.com/M4R7iNP/varnishls',
                    branch = 'main',
                    location = 'vendor/tree-sitter-' .. lang,
                    generate = true,
                    generate_from_json = false,
                    queries = 'vendor/tree-sitter-' .. lang .. '/queries',
                },
                tier = 1,
            }
        end
        cfg['alloy'] = {
            install_info = {
                url = 'https://github.com/Artemigos/tree-sitter-alloy',
                branch = 'main',
                files = { 'src/parser.c' },
            },
            tier = 1,
        }
    end,
})

return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate',
        config = function(_, opts)
            require('nvim-treesitter').setup(opts)
            require('nvim-treesitter').install({
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
            })
            vim.api.nvim_set_hl(0, 'TSPlaygroundFocus', { link = 'Search' })

            -- autoinstall and autostart parsers
            vim.api.nvim_create_autocmd('FileType', {
                pattern = '*',
                callback = function()
                    local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
                    if lang == nil then return end

                    local parsers = require('nvim-treesitter').get_available()
                    if vim.tbl_contains(parsers, lang) then
                        require('nvim-treesitter').install(lang):await(function()
                            if vim.treesitter.language.add(lang) then
                                vim.treesitter.start()
                            end
                        end)
                    elseif vim.treesitter.language.add(lang) then
                        vim.treesitter.start()
                    end
                end,
            })
        end,
        opts = {
            highlight = { enable = true },
            playground = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<c-up>',
                    node_incremental = '<c-up>',
                    node_decremental = '<c-down>',
                },
            },
        },
    },

    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
        opts = {
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
        },
        config = function(_, opts)
            require('nvim-treesitter-textobjects').setup(opts)

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
