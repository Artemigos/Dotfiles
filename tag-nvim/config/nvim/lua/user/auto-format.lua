local M = {}

function M.setup(opts)
    opts = opts or {}
    M.default_enabled_filetypes = opts.filetypes or {}
    M.augroup = vim.api.nvim_create_augroup('AutoFormat', { clear = true })
end

function M.on_attach(bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        if vim.lsp.buf.format then
            vim.lsp.buf.format()
        elseif vim.lsp.buf.formatting then
            vim.lsp.buf.formatting()
        end
    end, { desc = 'Format current buffer with LSP' })

    vim.api.nvim_buf_create_user_command(bufnr, 'ToggleAutoFormat', function(_)
        M.toggle_auto_format(bufnr)
    end, { desc = 'Toggle auto formatting for this buffer' })

    local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
    if vim.tbl_contains(M.default_enabled_filetypes, ft) then
        M.toggle_auto_format(bufnr)
    end
end

function M.toggle_auto_format(bufnr)
    local existingCmds = vim.api.nvim_get_autocmds({
        group = M.augroup,
        buffer = bufnr,
    })

    if vim.tbl_count(existingCmds) > 0 then
        for _, cmd in pairs(existingCmds) do
            vim.api.nvim_del_autocmd(cmd.id)
        end
    else
        vim.api.nvim_create_autocmd('BufWritePre', {
            command = 'Format',
            group = M.augroup,
            buffer = bufnr,
        })
    end
end

function M.is_auto_format_enabled(bufnr)
    local existingCmds = vim.api.nvim_get_autocmds({
        group = M.augroup,
        buffer = bufnr,
    })

    return vim.tbl_count(existingCmds) > 0
end

return M
