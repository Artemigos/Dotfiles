vim.pack.add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
    {
        src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
        version = 'main',
    },
    'https://github.com/folke/todo-comments.nvim',
})

-- register extra parsers
vim.api.nvim_create_autocmd('User', {
    pattern = 'TSUpdate',
    callback = function()
        local cfg = require('nvim-treesitter.parsers')
        for _, lang in pairs({ 'vcl', 'vtc' }) do
            cfg[lang] = {
                ---@diagnostic disable-next-line: missing-fields - want the HEAD revision
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
            ---@diagnostic disable-next-line: missing-fields - want the HEAD revision
            install_info = {
                url = 'https://github.com/Artemigos/tree-sitter-alloy',
                branch = 'main',
                queries = 'queries',
            },
            tier = 1,
        }
    end,
})

-- nvim-treesitter
require('nvim-treesitter').setup({})
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

-- autoinstall and autostart parsers
local function start_ts(bufnr, lang)
    if vim.treesitter.language.add(lang) then
        vim.treesitter.start(bufnr, lang)

        if vim.tbl_contains({'diff', 'gitcommit'}, lang) then
            vim.bo[bufnr].syntax = 'ON'
        end
    end
end

vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function(ev)
        local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
        if lang == nil then return end

        local parsers = require('nvim-treesitter').get_available()
        if vim.tbl_contains(parsers, lang) then
            require('nvim-treesitter').install(lang):await(function()
                start_ts(ev.buf, lang)
            end)
        else
            start_ts(ev.buf, lang)
        end
    end,
})

-- nvim-treesitter-textobjects
require('nvim-treesitter-textobjects').setup({
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
})

local function textobjectMap(mode, key, module, fn_name, query)
    vim.keymap.set(
        mode,
        key,
        function()
            require('nvim-treesitter-textobjects.' .. module)[fn_name](query)
        end,
        { desc = query }
    )
end

local function textobjectSelectMap(key, query)
    textobjectMap({ 'x', 'o' }, key, 'select', 'select_textobject', query)
end

local function textobjectSwapMap(key, query, direction)
    textobjectMap('n', key, 'swap', 'swap_' .. direction, query)
end

local function textobjectMoveMap(key, query, direction)
    textobjectMap({ 'n', 'x', 'o' }, key, 'move', 'goto_' .. direction, query)
end

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

-- todo-comments.nvim
require('todo-comments').setup({})
vim.keymap.set('n', '<Leader>fT', '<cmd>TodoTelescope<CR>')
