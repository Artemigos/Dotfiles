local u = require('utils')
local nmap = u.nmap
local imap = u.imap
local vmap = u.vmap

-- keybindings
nmap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
nmap('gD', '<cmd>lua vim.lsp.buf.implementation()<CR>')
nmap('gr', '<cmd>lua vim.lsp.buf.references()<CR>')
nmap('g<Space>', '<cmd>lua vim.lsp.buf.hover()<CR>')
nmap('ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
vmap('ga', ':<C-U>lua vim.lsp.buf.range_code_action()<CR>')
nmap('gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
imap('<C-Space>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
nmap('<C-Space>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
nmap('gT', ':Telescope lsp_dynamic_workspace_symbols<CR>')
nmap('gX', ':Telescope diagnostics<CR>')

-- leader keybindings
u.which_key_leader({
    c = { name = '+code' },
    r = { name = '+refactor' }
})

nmap('<Leader>cd', '<cmd>lua vim.lsp.buf.definition()<CR>')
nmap('<Leader>cD', '<cmd>lua vim.lsp.buf.implementation()<CR>')
nmap('<Leader>cr', '<cmd>lua vim.lsp.buf.references()<CR>')
nmap('<Leader>c<Space>', '<cmd>lua vim.lsp.buf.hover()<CR>')
nmap('<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
vmap('<Leader>ca', ':<C-U>lua vim.lsp.buf.range_code_action()<CR>')
nmap('<Leader>ct', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
nmap('<Leader>cT', ':Telescope lsp_dynamic_workspace_symbols<CR>')
nmap('<Leader>cX', ':Telescope diagnostics<CR>')

nmap('<Leader>rr', '<cmd>lua vim.lsp.buf.rename()<CR>')

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

require('lsp_signature').setup {}
require('lspkind').init {}

local supported_servers = {
    -- 'omnisharp', -- C#
    'bashls', -- bash
    'rust_analyzer', -- Rust
    'jsonls', -- JSON
    'sumneko_lua', -- LUA
    'jedi_language_server', -- Python
    'vimls', -- VimL
    'yamlls', -- YAML
    'cssls', -- CSS, LESS, SCSS
    'tsserver', -- Typescript, Javascript
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

    if server == 'sumneko_lua' then
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
    elseif server == 'omnisharp' then
        cfg.cmd = { 'OmniSharp', '--languageserver', '--hostPID', tostring(vim.fn.getpid()) }
    end

    return cfg
end

local lspconfig = require('lspconfig')
for _, server in pairs(supported_servers) do
    lspconfig[server].setup(make_config(server))
end
