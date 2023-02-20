local u = require('user.utils')

-- keybindings
u.map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
u.map('n', 'gD', '<cmd>lua vim.lsp.buf.implementation()<CR>')
u.map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
u.map('n', 'g<Space>', '<cmd>lua vim.lsp.buf.hover()<CR>')
u.map('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
u.map('v', 'ga', ':<C-U>lua vim.lsp.buf.range_code_action()<CR>')
u.map('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
u.map('i', '<C-Space>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
u.map('n', '<C-Space>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
u.map('n', 'gT', ':Telescope lsp_dynamic_workspace_symbols<CR>')
u.map('n', 'gX', ':Telescope diagnostics<CR>')

-- leader keybindings
u.which_key_leader({
    c = { name = '+code' },
    r = { name = '+refactor' }
})

u.map('n', '<Leader>cd', '<cmd>lua vim.lsp.buf.definition()<CR>')
u.map('n', '<Leader>cD', '<cmd>lua vim.lsp.buf.implementation()<CR>')
u.map('n', '<Leader>cr', '<cmd>lua vim.lsp.buf.references()<CR>')
u.map('n', '<Leader>c<Space>', '<cmd>lua vim.lsp.buf.hover()<CR>')
u.map('n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
u.map('v', '<Leader>ca', ':<C-U>lua vim.lsp.buf.range_code_action()<CR>')
u.map('n', '<Leader>ct', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
u.map('n', '<Leader>cT', ':Telescope lsp_dynamic_workspace_symbols<CR>')
u.map('n', '<Leader>cX', ':Telescope diagnostics<CR>')

u.map('n', '<Leader>rr', '<cmd>lua vim.lsp.buf.rename()<CR>')

-- diagnostic signs
vim.cmd [[
sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=
sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=
sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=
sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=
]]

-- show diagnostics when cursor is on it
-- TODO: does not work, figure out how to fix
-- vim.api.nvim_create_augroup('reference_highlight', { clear = true })
-- vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
--     group = 'reference_highlight',
--     callback = vim.lsp.buf.document_highlight,
-- })
-- vim.api.nvim_create_autocmd('CursorMoved', {
--     group = 'reference_highlight',
--     callback = vim.lsp.buf.clear_references,
-- })

require('lsp_signature').setup {
    bind = true,
    handler_opts = {
        border = 'rounded',
    },
}
require('lspkind').init {}

local supported_servers = {
    'bashls', -- bash
    'rust_analyzer', -- Rust
    'jsonls', -- JSON
    'lua_ls', -- LUA
    'pyright', -- Python
    'vimls', -- VimL
    'yamlls', -- YAML
    'cssls', -- CSS, LESS, SCSS
    'tsserver', -- Typescript, Javascript
    'ruff_lsp', -- python linter
}

require('mason').setup({
    ui = {
        border = 'rounded',
    },
})
require('mason-lspconfig').setup({
    ensure_installed = supported_servers
})

local on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        if vim.lsp.buf.format then
            vim.lsp.buf.format()
        elseif vim.lsp.buf.formatting then
            vim.lsp.buf.formatting()
        end
    end, { desc = 'Format current buffer with LSP' })
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local function make_config(server)
    local cfg = {
        on_attach = on_attach,
        capabilities = capabilities,
    }

    if server == 'lua_ls' then
        local runtime_path = vim.split(package.path, ';')
        table.insert(runtime_path, "lua/?.lua")
        table.insert(runtime_path, "lua/?/init.lua")
        cfg.settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                    path = runtime_path,
                },
                diagnostics = {
                    globals = { 'vim' },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
                telemetry = {
                    enable = false,
                },
            },
        }
    elseif server == 'yamlls' then
        cfg = require('yaml-companion').setup({
            lspconfig = cfg,
        })
    end

    return cfg
end

local lspconfig = require('lspconfig')
for _, server in pairs(supported_servers) do
    lspconfig[server].setup(make_config(server))
end

require('lspconfig.ui.windows').default_options.border = 'rounded'
vim.lsp.handlers['textDocument/hover'] =
    vim.lsp.with(vim.lsp.handlers.hover, {
        border = 'rounded',
    })
