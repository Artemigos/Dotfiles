set noshowmode " do not show current mode in the command area

let g:lightline = {}
let g:lightline.colorscheme = 'dracula'
let g:lightline.mode_map = {
            \ 'n' : 'N',
            \ 'i' : 'I',
            \ 'R' : 'R',
            \ 'v' : 'V',
            \ 'V' : 'VL',
            \ "\<C-v>": 'VB',
            \ 'c' : 'C',
            \ }

let g:lightline.component_function = { 'git': 'FugitiveHead' }
let g:lightline.active = {
            \ 'left': [ [ 'mode' ],
            \           [ 'readonly', 'filename', 'modified', 'git' ] ],
            \ 'right': [ [ 'lineinfo' ],
            \            [ 'percent' ],
            \            [ 'fileformat', 'fileencoding', 'filetype' ] ],
            \ }

let g:lightline.tabline = {
            \ 'left': [ [ 'tabs' ] ],
            \ 'right': [],
            \ }

