local M = {}

function M.setup(opts)
    opts = opts or {}
    M.default_enabled_filetypes = opts.filetypes or {}
    M.augroup = vim.api.nvim_create_augroup('AutoFormat', { clear = true })

    vim.api.nvim_create_user_command('Format', function(args)
        local range = nil
        if args.count ~= -1 then
            local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
            range = {
                start = { args.line1, 0 },
                ["end"] = { args.line2, end_line:len() },
            }
        end
        require("conform").format({ lsp_fallback = true, range = range })
    end, { desc = 'Format current buffer', range = true })

    vim.api.nvim_create_user_command('ToggleAutoFormat', function(_)
        M.toggle_auto_format(0)
    end, { desc = 'Toggle auto formatting for this buffer' })

    vim.api.nvim_create_autocmd('FileType', {
        group = M.augroup,
        callback = function(ev)
            local should_enable = vim.tbl_contains(M.default_enabled_filetypes, ev.match)
            local is_enabled = M.is_auto_format_enabled(ev.buf)
            if should_enable ~= is_enabled then
                M.toggle_auto_format(ev.buf)
            end
        end,
    })
end

function M.toggle_auto_format(bufnr)
    local existingCmds = vim.api.nvim_get_autocmds({
        group = M.augroup,
        buffer = bufnr,
    })

    if #existingCmds > 0 then
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

    return #existingCmds > 0
end

return M
