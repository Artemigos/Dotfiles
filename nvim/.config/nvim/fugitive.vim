if exists('g:which_key_map')
    let g:which_key_map.g = { 'name': '+git' }
endif

if exists('plugs') && type(plugs) == type({}) && has_key(plugs, 'fzf') " this depends on vim-plug (I think) but that's the best I can do for now
    command! GitCheckoutBranch call fzf#run(fzf#wrap({ 'source': 'git branch | cut -c 3-', 'sink': 'G checkout' }))
    nnoremap <silent> <Leader>go :GitCheckoutBranch<CR>
endif

nnoremap <silent> <Leader>gg :Git<CR>
nnoremap <silent> <Leader>gi :Git commit<CR>
nnoremap <silent> <Leader>gl :Commits<CR>
nnoremap <silent> <Leader>gp :Git push<CR>

