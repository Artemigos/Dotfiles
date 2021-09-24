if exists('g:which_key_map')
    let g:which_key_map.g = { 'name': '+git' }
endif

nnoremap <silent> <Leader>gg :Git<CR>
nnoremap <silent> <Leader>gi :Git commit<CR>
nnoremap <silent> <Leader>gc :Telescope git_commits<CR>
nnoremap <silent> <Leader>gp :Git push<CR>
nnoremap <silent> <Leader>gl :Git pull<CR>
nnoremap <silent> <Leader>gb :Telescope git_branches<CR>
nnoremap <silent> <Leader>gs :Telescope git_stash<CR>
