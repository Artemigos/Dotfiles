call which_key#register('<Space>', "g:which_key_map")
let g:which_key_map =  {}
let g:which_key_timeout = 300
let g:which_key_use_floating_win = 1
let g:which_key_fallback_to_native_key = 1
let g:which_key_run_map_on_popup = 1

nnoremap <silent> <Leader> :<C-u>WhichKey '<Space>'<CR>
nnoremap <silent> <LocalLeader> :<C-u>WhichKey ','<CR>

