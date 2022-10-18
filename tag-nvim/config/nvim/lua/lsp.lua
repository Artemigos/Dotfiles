local set = vim.opt

-- clean up behavior of completion menu
set.completeopt = {'menuone', 'noinsert', 'noselect'}
set.shortmess:append('c')

-- some quality of life settings
set.signcolumn = 'yes'
set.cmdheight = 2

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
nmap('g[', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
nmap('g]', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
nmap('gx', '<cmd>lua vim.diagnostic.open_float()<CR>')
nmap('gT', ':Telescope lsp_dynamic_workspace_symbols<CR>')
nmap('gX', ':Telescope diagnostics<CR>')

-- leader keybindings
which_key_leader({
    c = {name='+code'},
    r = {name='+refactor'}
})

nmap('<Leader>cd', '<cmd>lua vim.lsp.buf.definition()<CR>')
nmap('<Leader>cD', '<cmd>lua vim.lsp.buf.implementation()<CR>')
nmap('<Leader>cr', '<cmd>lua vim.lsp.buf.references()<CR>')
nmap('<Leader>c<Space>', '<cmd>lua vim.lsp.buf.hover()<CR>')
nmap('<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
vmap('<Leader>ca', ':<C-U>lua vim.lsp.buf.range_code_action()<CR>')
nmap('<Leader>ct', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
nmap('<Leader>cx', '<cmd>lua vim.diagnostic.open_float()<CR>')
nmap('<Leader>cT', ':Telescope lsp_dynamic_workspace_symbols<CR>')
nmap('<Leader>cX', ':Telescope diagnostics<CR>')

nmap('<Leader>rr', '<cmd>lua vim.lsp.buf.rename()<CR>')

-- show diagnostics when cursor is on it
vim.cmd [[
    " autocmd! CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    " autocmd! CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
    autocmd! CursorMoved <buffer> lua vim.lsp.buf.clear_references()
]]

require('lsp_signature').setup {}
require('lspkind').init {}

local supported_servers = {
    'omnisharp', -- C#
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

local on_attach = function(_)
    vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

local function make_config(server)
    local cfg = {
        on_attach = on_attach,
        capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
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
                    globals = {'vim'},
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
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
