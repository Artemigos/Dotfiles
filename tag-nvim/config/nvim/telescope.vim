lua << EOF
local telescope = require'telescope'

telescope.setup {
    extensions = {
        lsp_handlers = {
            code_action = {
                telescope = require'telescope.themes'.get_cursor{},
            }
        }
    }
}

telescope.load_extension('fzf')
telescope.load_extension('lsp_handlers')
EOF

if exists('g:which_key_map')
    let g:which_key_map.f = { 'name': '+telescope' }
endif

nnoremap <silent> <Leader>ff :Telescope find_files<CR>
nnoremap <silent> <Leader>fg :Telescope git_files<CR>
nnoremap <silent> <Leader>fb :Telescope buffers<CR>
nnoremap <silent> <Leader>f/ :Telescope live_grep<CR>
nnoremap <silent> <Leader>fd :Telescope file_browser<CR>
nnoremap <silent> <Leader>fc :Telescope commands<CR>
nnoremap <silent> <Leader>fh :Telescope help_tags<CR>
nnoremap <silent> <Leader>f<Space> :Telescope builtin<CR>
