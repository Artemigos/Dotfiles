vim.opt.showmode = false

vim.g.lightline = {
    enable = {
        statusline = 1,
        tabline = 0,
    },
    colorscheme = 'dracula',
    mode_map = {
        n = 'N',
        i = 'I',
        R = 'R',
        v = 'V',
        V = 'VL',
        [''] = 'VB',
        c = 'C',
    },
    component_function = {git = 'FugitiveHead'},
    active = {
        left = {{'mode'}, {'readonly', 'filename', 'modified', 'git'}},
        right = {{'lineinfo'}, {'percent'}, {'fileformat', 'fileencoding', 'filetype'}}
    },
}

