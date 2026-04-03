local function copilot_condition()
    return require('user.localconf').get_toggle('copilot')
end

return {
    {
        'github/copilot.vim',
        cond = copilot_condition,
        event = 'VeryLazy',
        config = function()
            vim.g.copilot_filetypes = {
                text = false,
            }
            vim.g.copilot_no_tab_map = true
            vim.keymap.set('i', '<M-Enter>', 'copilot#Accept("\\<CR>")', {
                expr = true,
                replace_keycodes = false,
            })
        end,
    },
}
