if exists('g:which_key_map')
    let g:which_key_map.f = { 'name': '+fzf' }
endif

nnoremap <silent> <Leader>ff :Files<CR>
nnoremap <silent> <Leader>fg :GitFiles<CR>
nnoremap <silent> <Leader>fb :Buffers<CR>

let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }

