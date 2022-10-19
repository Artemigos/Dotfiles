vim.api.nvim_create_augroup('special_files', { clear = true })
vim.api.nvim_create_autocmd('BufRead', {
    group = 'special_files',
    pattern = 'tridactylrc',
    callback = function()
        vim.wo.foldmethod = 'marker'
        vim.wo.foldmarker = '"{,}"'
    end,
})
