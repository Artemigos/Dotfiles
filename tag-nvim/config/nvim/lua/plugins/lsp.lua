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

return {
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            {
                'williamboman/mason.nvim',
                opts = {
                    ui = {
                        border = 'rounded',
                    },
                },
            },
            {
                'williamboman/mason-lspconfig.nvim',
                opts = {
                    ensure_installed = supported_servers,
                },
            },
            {
                'ray-x/lsp_signature.nvim',
                opts = {
                    bind = true,
                    handler_opts = {
                        border = 'rounded',
                    },
                },
            },
            {
                'onsails/lspkind-nvim',
                opts = {},
                config = function(_, opts)
                    require('lspkind').init(opts)
                end,
            },
            {
                "someone-stole-my-name/yaml-companion.nvim",
                event = { 'BufReadPre', 'BufNewFile' },
                dependencies = {
                    "neovim/nvim-lspconfig",
                    "nvim-lua/plenary.nvim",
                    "nvim-telescope/telescope.nvim",
                },
                config = function()
                    require("telescope").load_extension("yaml_schema")
                end,
            },
        },
        keys = {
            { 'gd', vim.lsp.buf.definition, desc = 'Go to definition' },
            { 'gD', vim.lsp.buf.implementation, desc = 'Go to implementation' },
            { 'gr', vim.lsp.buf.references, desc = 'References' },
            { 'g<Space>', vim.lsp.buf.hover, desc = 'Hint' },
            { 'ga', vim.lsp.buf.code_action, mode = { 'n', 'v' }, desc = 'Show code actions' },
            { 'gt', vim.lsp.buf.type_definition, desc = 'Go to type definition' },
            { '<C-Space>', vim.lsp.buf.signature_help, mode = 'i', desc = 'Signature help' },
            { '<C-Space>', vim.lsp.buf.signature_help, desc = 'Signature help' },
            { 'gT', ':Telescope lsp_dynamic_workspace_symbols<CR>', desc = 'Workspace symbols' },
            { 'gX', ':Telescope diagnostics<CR>', desc = 'Diagnostics' },

            { '<Leader>cd', vim.lsp.buf.definition, desc = 'Go to definition' },
            { '<Leader>cD', vim.lsp.buf.implementation, desc = 'Go to implementation' },
            { '<Leader>cr', vim.lsp.buf.references, desc = 'References' },
            { '<Leader>c<Space>', vim.lsp.buf.hover, desc = 'Hint' },
            { '<Leader>ca', vim.lsp.buf.code_action, mode = { 'n', 'v' }, desc = 'Show code actions' },
            { '<Leader>ct', vim.lsp.buf.type_definition, desc = 'Go to type definition' },
            { '<Leader>cT', ':Telescope lsp_dynamic_workspace_symbols<CR>', desc = 'Workspace symbols' },
            { '<Leader>cX', ':Telescope diagnostics<CR>', desc = 'Diagnostics' },

            { '<Leader>rr', vim.lsp.buf.rename, desc = 'Rename' },
        },
        config = function()
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
        end,
    },

    -- null-ls
    { 'jose-elias-alvarez/null-ls.nvim' },
    {
        'jayp0521/mason-null-ls.nvim',
        config = function() require('user.null-ls') end
    },
}
