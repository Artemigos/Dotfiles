local u = require('user.utils')
local telescope = require('telescope')

telescope.setup {
    extensions = {
        lsp_handlers = {
            code_action = {
                telescope = require('telescope.themes').get_cursor{},
            }
        },
        ['ui-select'] =  {
            require('telescope.themes').get_dropdown {}
        }
    }
}

u.which_key_leader({ f = { name = '+telescope' } })

u.map('n', '<Leader>ff', ':Telescope find_files<CR>')
u.map('n', '<Leader>fg', ':Telescope git_files<CR>')
u.map('n', '<Leader>fb', ':Telescope buffers<CR>')
u.map('n', '<Leader>f/', ':Telescope live_grep<CR>')
u.map('n', '<Leader>fd', ':Telescope file_browser<CR>')
u.map('n', '<Leader>fc', ':Telescope commands<CR>')
u.map('n', '<Leader>fh', ':Telescope help_tags<CR>')
u.map('n', '<Leader>f<Space>', ':Telescope builtin<CR>')
u.map('n', '<Leader>fm', ':lua require("user.pickers").makefile()<CR>')
u.map('n', '<Leader>fr', require('telescope.builtin').resume)
