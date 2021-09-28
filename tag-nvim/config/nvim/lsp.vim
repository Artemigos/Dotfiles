" clean up behavior of completion menu
set completeopt=menuone,noinsert,noselect
set shortmess+=c

" some quality of life settings
set signcolumn=yes
set cmdheight=2

" keybindings
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g<Space> <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> ga <cmd>lua vim.lsp.buf.code_action()<CR>
vnoremap <silent> ga :<C-U>lua vim.lsp.buf.range_code_action()<CR>
nnoremap <silent> gt <cmd>lua vim.lsp.buf.type_definition()<CR>
inoremap <silent> <C-Space> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <C-Space> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> gx <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> gT :Telescope lsp_dynamic_workspace_symbols<CR>
nnoremap <silent> gX :Telescope lsp_document_diagnostics<CR>

" Leader keybindings
if exists('g:which_key_map')
    let g:which_key_map.c = { 'name': '+code' }
    let g:which_key_map.r = { 'name': '+refactor' }
endif

nmap <silent> <Leader>cd <cmd>lua vim.lsp.buf.definition()<CR>
nmap <silent> <Leader>cD <cmd>lua vim.lsp.buf.implementation()<CR>
nmap <silent> <Leader>cr <cmd>lua vim.lsp.buf.references()<CR>
nmap <silent> <Leader>c<Space> <cmd>lua vim.lsp.buf.hover()<CR>
nmap <silent> <Leader>ca <cmd>lua vim.lsp.buf.code_action()<CR>
vmap <silent> <Leader>ca :<C-U>lua vim.lsp.buf.range_code_action()<CR>
nmap <silent> <Leader>ct <cmd>lua vim.lsp.buf.type_definition()<CR>
nmap <silent> <Leader>cx <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nmap <silent> <Leader>cT :Telescope lsp_dynamic_workspace_symbols<CR>
nmap <silent> <Leader>cX :Telescope lsp_document_diagnostics<CR>

nmap <silent> <Leader>rr <cmd>lua vim.lsp.buf.rename()<CR>

" show diagnostics when cursor is on it
" autocmd! CursorHold <buffer> lua vim.lsp.buf.document_highlight()
" autocmd! CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
autocmd! CursorMoved <buffer> lua vim.lsp.buf.clear_references()

lua << EOF
require'nvim-web-devicons'.setup {
    default = true
}
require'lspkind'.init {}

local cmp = require'cmp'

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<Tab>'] = function(fallback)
            if vim.fn.pumvisible() ~= 0 then
                cmp.select_next_item()
            else
                cmp.complete()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if vim.fn.pubvisible() ~= 0 then
                cmp.select_prev_item()
            else
                fallback()
            end
        end,
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = 'buffer' },
    }
})

local supported_languages = {
    'csharp',
    'bash',
    'rust',
    'json',
    'lua',
    'python',
    'vim',
    'yaml',
}

local on_attach = function(client)
    vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    require('lsp_signature').on_attach {
        extra_trigger_chars = {'(', ','}
    }
end

local function make_config(server)
    local cfg = {
        on_attach = on_attach,
        capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    }

    if server == 'lua' then
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
    end

    return cfg
end

local lspinstall = require'lspinstall'
local function setup_servers()
    local lspconfig = require'lspconfig'
    lspinstall.setup()
    local servers = lspinstall.installed_servers()
    for _, server in pairs(servers) do
        local config = make_config(server)
        lspconfig[server].setup(config)
    end
end

local function install_servers()
    local servers = lspinstall.installed_servers()
    local to_install = {}
    for _, server in pairs(supported_languages) do
        to_install[server] = true
    end
    for _, server in pairs(servers) do
        to_install[server] = nil
    end
    for server, _ in pairs(to_install) do
        lspinstall.install_server(server)
    end
end

install_servers()
setup_servers()

lspinstall.post_install_hook = function ()
    setup_servers()
    vim.cmd('bufdo e')
end
EOF
