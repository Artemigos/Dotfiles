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

telescope.load_extension('fzf')
telescope.load_extension('file_browser')
telescope.load_extension('lsp_handlers')

which_key_leader({ f = { name = '+telescope' } })

nmap('<Leader>ff', ':Telescope find_files<CR>')
nmap('<Leader>fg', ':Telescope git_files<CR>')
nmap('<Leader>fb', ':Telescope buffers<CR>')
nmap('<Leader>f/', ':Telescope live_grep<CR>')
nmap('<Leader>fd', ':Telescope file_browser<CR>')
nmap('<Leader>fc', ':Telescope commands<CR>')
nmap('<Leader>fh', ':Telescope help_tags<CR>')
nmap('<Leader>f<Space>', ':Telescope builtin<CR>')
