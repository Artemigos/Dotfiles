local function t(type)
    local function picker()
        require('telescope.builtin')[type]()
    end

    return picker
end

return {
    { 'nvim-lua/plenary.nvim', lazy = true },

    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        cmd = 'Telescope',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            { 'nvim-telescope/telescope-file-browser.nvim' },
            { 'gbrlsnchs/telescope-lsp-handlers.nvim' },
        },
        opts = {
            extensions = {
                lsp_handlers = {
                    code_action = {
                        telescope = require('telescope.themes').get_cursor {},
                    }
                },
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown {}
                }
            }
        },
        keys = {
            { '<Leader>ff', t('find_files'), desc = 'Find file' },
            { '<Leader>fg', t('git_files'), desc = 'Find git file' },
            { '<Leader>fb', t('buffers'), desc = 'Find buffer' },
            { '<Leader>f/', t('live_grep'), desc = 'Live grep' },
            { '<Leader>fd', ':Telescope file_browser<CR>', desc = 'File browser' },
            { '<Leader>fc', t('commands'), desc = 'Find command' },
            { '<Leader>fh', t('help_tags'), desc = 'Find help' },
            { '<Leader>f<Space>', t('builtin'), desc = 'Find telescope mode' },
            { '<Leader>fm', require("user.pickers").makefile, desc = 'Run make target' },
            { '<Leader>fr', t('resume'), desc = 'Resume last search' },
        },
        config = function(_, opts)
            local ts = require('telescope')
            ts.setup(opts)
            ts.load_extension('fzf')
            ts.load_extension('file_browser')
            ts.load_extension('lsp_handlers')
        end
    },

    {
        'stevearc/dressing.nvim',
        lazy = true,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require('lazy').load({ plugins = { 'dressing.nvim' } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require('lazy').load({ plugins = { 'dressing.nvim' } })
                return vim.ui.input(...)
            end
        end,
    },
}
