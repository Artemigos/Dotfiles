local function t(type, opts)
    local function picker()
        require('telescope.builtin')[type](opts or {})
    end

    return picker
end

return {
    { 'nvim-lua/plenary.nvim', lazy = true },

    {
        'nvim-telescope/telescope.nvim',
        version = '*',
        cmd = 'Telescope',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        },
        keys = {
            { '<Leader>ff',       t('find_files'),                                      desc = 'Find file' },
            { '<Leader>fg',       t('git_files'),                                       desc = 'Find git file' },
            { '<Leader>fb',       t('buffers'),                                         desc = 'Find buffer' },
            { '<Leader>f/',       t('live_grep', { additional_args = { '--hidden' } }), desc = 'Live grep' },
            { '<Leader>fc',       t('commands'),                                        desc = 'Find command' },
            { '<Leader>fh',       t('help_tags'),                                       desc = 'Find help' },
            { '<Leader>f<Space>', t('builtin'),                                         desc = 'Find telescope mode' },
            { '<Leader>fm',       require("user.pickers").makefile,                     desc = 'Run make target' },
            { '<Leader>fr',       t('resume'),                                          desc = 'Resume last search' },
            { '<Leader>fs',       t('lsp_document_symbols'),                            desc = 'Find symbols in this file' },
        },
        config = function(_, _)
            local ts = require('telescope')
            ts.setup({})
            ts.load_extension('fzf')
        end
    },
}
