if exists('g:which_key_map')
    let g:which_key_map.b = { 'name': '+buffers' }
    let g:which_key_map.i = { 'name': '+init.vim' }
    let g:which_key_map.w = { 'name': '+windows' }
    let g:which_key_map.w.h = 'left-window'
    let g:which_key_map.w.j = 'bottom-window'
    let g:which_key_map.w.k = 'top-window'
    let g:which_key_map.w.l = 'right-window'
    let g:which_key_map.t = { 'name': '+tabs' }
    let g:which_key_map.t.n = 'next-tab'
    let g:which_key_map.t.p = 'previous-tab'
endif

" working with init.vim
command! EditInit e $MYVIMRC
command! SourceInit source $MYVIMRC
nnoremap <Leader>ie :EditInit<CR>
nnoremap <Leader>is :SourceInit<CR>

au! BufWritePost $MYVIMRC source $MYVIMRC

" buffer switching
nnoremap <silent> <C-n> :bnext<CR>
nnoremap <silent> <C-p> :bprev<CR>
nnoremap <silent> <Leader>bn :bnext<CR>
nnoremap <silent> <Leader>bp :bprev<CR>

" split switching
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <Leader>wh <C-w>h
nnoremap <Leader>wj <C-w>j
nnoremap <Leader>wk <C-w>k
nnoremap <Leader>wl <C-w>l

" tab navigation
nnoremap <TAB> gt
nnoremap <S-TAB> gT
nnoremap <Leader>tn gt
nnoremap <Leader>tp gT

" other
nnoremap <silent> <Space><Space><Space> :nohl<CR>
