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
        root_dir = vim.loop.cwd(),
    })
end, {})

vim.api.nvim_create_user_command('MarkdownStopPreview', function()
    local client = find_mdpls()
    if client then
        client.stop()
    else
        vim.notify('No preview server running', vim.log.levels.INFO)
    end
end, {})

vim.api.nvim_create_autocmd('BufEnter', {
    buffer = 0,
    callback = function()
        local client = find_mdpls()
        if client then
            vim.lsp.buf_attach_client(0, client.id)
        end
    end,
    group = vim.api.nvim_create_augroup('mdpls_attach_client', {}),
})
