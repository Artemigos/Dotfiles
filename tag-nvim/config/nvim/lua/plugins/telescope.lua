vim.pack.add({
    'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
    {
        src = 'https://github.com/nvim-telescope/telescope.nvim',
        version = 'v0.2.2',
    },
})

local function t(type, opts)
    local function picker()
        require('telescope.builtin')[type](opts or {})
    end

    return picker
end

-- telescope.nvim
local ts = require('telescope')
ts.setup({})
ts.load_extension('fzf')

vim.keymap.set('n', '<Leader>ff', t('find_files'), { desc = 'Find file' })
vim.keymap.set('n', '<Leader>fg', t('git_files'), { desc = 'Find git file' })
vim.keymap.set('n', '<Leader>fb', t('buffers'), { desc = 'Find buffer' })
vim.keymap.set('n', '<Leader>f/', t('live_grep', { additional_args = { '--hidden' } }), { desc = 'Live grep' })
vim.keymap.set('n', '<Leader>fc', t('commands'), { desc = 'Find command' })
vim.keymap.set('n', '<Leader>fh', t('help_tags'), { desc = 'Find help' })
vim.keymap.set('n', '<Leader>f<Space>', t('builtin'), { desc = 'Find telescope mode' })
vim.keymap.set('n', '<Leader>fm', require("user.pickers").makefile, { desc = 'Run make target' })
vim.keymap.set('n', '<Leader>fr', t('resume'), { desc = 'Resume last search' })
vim.keymap.set('n', '<Leader>fs', t('lsp_document_symbols'), { desc = 'Find symbols in this file' })
