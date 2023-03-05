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
        'williamboman/mason.nvim',
        cmd = 'Mason',
        opts = {
            ui = {
                border = 'rounded',
            },
        },
    },
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            'williamboman/mason.nvim',
            {
                'williamboman/mason-lspconfig.nvim',
                opts = {
                    ensure_installed = supported_servers,
                },
            },
            {
                'jayp0521/mason-null-ls.nvim',
                dependencies = {
                    'jose-elias-alvarez/null-ls.nvim',
                },
                opts = {
                    ensure_installed = nil,
                    automatic_installation = true,
                    automatic_setup = false,
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
    {
        'jose-elias-alvarez/null-ls.nvim',
        dependencies = {
            'williamboman/mason.nvim',
        },
        event = { 'BufReadPre', 'BufNewFile' },
        keys = {
            { 'gF', '<cmd>Format<CR>', desc = 'Format code' },
            { '<leader>cF', '<cmd>Format<CR>', desc = 'Format code' },
        },
        opts = function()
            local u = require('user.utils')
            local null_ls = require('null-ls')
            local formatter_factory = require('null-ls.helpers').formatter_factory

            local yq = {
                name = 'yq',
                method = null_ls.methods.FORMATTING,
                generator = formatter_factory({ command = 'yq', to_stdin = true, }),
                filetypes = { 'yaml' },
            }

            return {
                border = 'rounded',
                sources = {
                    -- code actions
                    null_ls.builtins.code_actions.shellcheck,
                    null_ls.builtins.code_actions.gitrebase,
                    -- null_ls.builtins.code_actions.eslint,
                    -- null_ls.builtins.code_actions.refactoring,

                    -- diagnostics
                    null_ls.builtins.diagnostics.editorconfig_checker,
                    null_ls.builtins.diagnostics.fish,
                    null_ls.builtins.diagnostics.mypy.with({
                        extra_args = function(_)
                            local found, python = pcall(u.exec, 'which python3')
                            if not found then
                                python = u.exec('which python')
                            end
                            return {
                                -- get around venv problems by using the current venv neovim is in
                                '--python-executable',
                                vim.trim(python),
                            }
                        end,
                    }),
                    -- null_ls.builtins.diagnostics.eslint,
                    -- null_ls.builtins.diagnostics.hadolint,
                    -- null_ls.builtins.diagnostics.markdownlint,
                    -- null_ls.builtins.diagnostics.selene,
                    -- null_ls.builtins.diagnostics.yamllint,

                    -- formatters
                    null_ls.builtins.formatting.fish_indent,
                    null_ls.builtins.formatting.shfmt,
                    yq,
                    null_ls.builtins.formatting.black,
                    -- null_ls.builtins.formatting.prettierd,
                    -- null_ls.builtins.formatting.lua_format,
                    -- null_ls.builtins.formatting.markdownlint,
                    -- null_ls.builtins.formatting.rustfmt,
                },
            }

            -- TODO: verify what's needed, languages: Lua, TS, Rust, Markdown
        end,
    },
}
