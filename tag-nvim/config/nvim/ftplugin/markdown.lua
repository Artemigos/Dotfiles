vim.wo.conceallevel = 1

local function find_mdpls()
    local clients = vim.lsp.get_clients({ name = 'mdpls' })
    if #clients > 0 then
        return clients[1]
    end
end

vim.api.nvim_create_user_command('MarkdownPreview', function()
    local client = find_mdpls()
    if client then
        vim.notify('Preview server already running', vim.log.levels.INFO)
        return
    end
    vim.lsp.start({
        name = 'mdpls',
        cmd = { 'mdpls' },
        settings = {
            markdown = {
                preview = {
                    codeTheme = 'github-dark',
                    serveStatic = true,
                },
            },
        },
        root_dir = vim.uv.cwd(),
    })
end, {})

vim.api.nvim_create_user_command('MarkdownStopPreview', function()
    local client = find_mdpls()
    if client then
        client:stop()
    else
        vim.notify('No preview server running', vim.log.levels.INFO)
    end
end, {})

local function make_did_open_params(buf)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, true)
    return {
        textDocument = {
            uri = vim.uri_from_bufnr(buf),
            languageId = vim.bo[buf].filetype,
            version = vim.lsp.util.buf_versions[buf],
            text = table.concat(lines, '\n'),
        },
    }
end

vim.api.nvim_create_autocmd('BufEnter', {
    buffer = vim.api.nvim_get_current_buf(),
    callback = function(ev)
        local client = find_mdpls()
        if client then
            vim.lsp.buf_attach_client(ev.buf, client.id)
            -- NOTE: it's a little hacky (this is misuse of textDocument/didOpen), but the best way I found in mdpls's code
            client:notify('textDocument/didOpen', make_did_open_params(ev.buf))
        end
    end,
})
