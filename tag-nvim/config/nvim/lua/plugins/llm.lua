if require('user.localconf').get_toggle('copilot') then
    vim.pack.add({
        'https://github.com/github/copilot.vim',
    })
    vim.g.copilot_filetypes = {
        text = false,
    }
    vim.g.copilot_no_tab_map = true
    vim.keymap.set('i', '<M-Enter>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
    })
end
