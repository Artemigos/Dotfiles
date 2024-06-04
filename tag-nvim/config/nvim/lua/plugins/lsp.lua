local supported_servers = {
    'bashls',        -- bash
    'rust_analyzer', -- Rust
    'jsonls',        -- JSON
    'lua_ls',        -- LUA
    'pyright',       -- Python
    'vimls',         -- VimL
    'yamlls',        -- YAML
    'cssls',         -- CSS, LESS, SCSS
    'tsserver',      -- Typescript, Javascript
    'ruff_lsp',      -- python linter
    'gopls',         -- Golang
    'marksman',      -- Markdown notetaking
}

local auto_install_tools = {
    -- DAPs
    'bash-debug-adapter',
    'codelldb',
    'go-debug-adapter',
    'js-debug-adapter',
    -- linters
    'mypy',
    'shellcheck',
    -- formatters
    'isort',
    'black',
    'gofumpt',
    'shfmt',
}

local function on_attach(_, bufnr)
    vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = 0 })
    require('user.auto-format').on_attach(bufnr)
end

return {
    {
        'williamboman/mason.nvim',
        cmd = 'Mason',
        opts = {
            ui = {
                border = 'rounded',
            },
        },
        init = function(_)
            local reg = require('mason-registry')
            for _, tool in ipairs(auto_install_tools) do
                if not reg.is_installed(tool) then
                    local ok, pkg = pcall(reg.get_package, tool)
                    if ok then
                        vim.notify('[Mason] Installing ' .. tool .. '...', vim.log.levels.INFO)
                        pkg:install()
                    end
                end
            end
        end,
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
            { 'gd',       vim.lsp.buf.definition,     desc = 'Go to definition' },
            { 'gD',       vim.lsp.buf.implementation, desc = 'Go to implementation' },
            { 'gr',       vim.lsp.buf.references,     desc = 'References' },
            { 'g<Space>', vim.lsp.buf.hover,          desc = 'Hint' },
            {
                'ga',
                vim.lsp.buf.code_action,
                mode = { 'n', 'v' },
                desc =
                'Show code actions'
            },
            { 'gt',               vim.lsp.buf.type_definition,                    desc = 'Go to type definition' },
            {
                '<C-Space>',
                vim.lsp.buf.signature_help,
                mode = 'i',
                desc =
                'Signature help'
            },
            { '<C-Space>',        vim.lsp.buf.signature_help,                     desc = 'Signature help' },
            { 'gT',               ':Telescope lsp_dynamic_workspace_symbols<CR>', desc = 'Workspace symbols' },
            { 'gX',               ':Telescope diagnostics<CR>',                   desc = 'Diagnostics' },
            { 'gA',               ':ToggleAutoFormat<CR>',                        desc = 'Toggle auto formatting' },
            { '<Leader>cd',       vim.lsp.buf.definition,                         desc = 'Go to definition' },
            { '<Leader>cD',       vim.lsp.buf.implementation,                     desc = 'Go to implementation' },
            { '<Leader>cr',       vim.lsp.buf.references,                         desc = 'References' },
            { '<Leader>c<Space>', vim.lsp.buf.hover,                              desc = 'Hint' },
            {
                '<Leader>ca',
                vim.lsp.buf.code_action,
                mode = { 'n', 'v' },
                desc =
                'Show code actions'
            },
            { '<Leader>ct', vim.lsp.buf.type_definition,                    desc = 'Go to type definition' },
            { '<Leader>cT', ':Telescope lsp_dynamic_workspace_symbols<CR>', desc = 'Workspace symbols' },
            { '<Leader>cX', ':Telescope diagnostics<CR>',                   desc = 'Diagnostics' },
            { '<Leader>cA', ':ToggleAutoFormat<CR>',                        desc = 'Toggle auto formatting' },
            { '<Leader>rr', vim.lsp.buf.rename,                             desc = 'Rename' },
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

    {
        'stevearc/conform.nvim',
        event = { 'BufWritePre' },
        cmd = { 'ConformInfo' },
        keys = {
            { 'gF',         '<cmd>Format<CR>', desc = 'Format code' },
            { '<leader>cF', '<cmd>Format<CR>', desc = 'Format code' },
        },
        opts = {
            formatters_by_ft = {
                python = { 'isort', 'black' },
                go = { 'gofumpt' },
                sh = { 'shfmt' },
                fish = { 'fish_indent' },
                yaml = { 'yq' },
            },
            -- TODO:
            -- local vcl_formatter = {
            --     name = 'vcl-formatter',
            --     method = null_ls.methods.FORMATTING,
            --     generator = formatter_factory({
            --         command = 'vcl-formatter',
            --         to_stdin = true,
            --         args = function(params)
            --             local indent = vim.api.nvim_buf_get_option(params.bufnr, 'shiftwidth')
            --             return { '-i', tostring(indent), '-' }
            --         end,
            --     }),
            --     filetypes = { 'vcl' },
            -- }
        },
        init = function()
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
    },

    -- null-ls
    {
        'jose-elias-alvarez/null-ls.nvim',
        dependencies = {
            'williamboman/mason.nvim',
        },
        event = { 'BufReadPre', 'BufNewFile' },
        opts = function()
            local u = require('user.utils')
            local null_ls = require('null-ls')

            return {
                border = 'rounded',
                should_attach = function(bufnr)
                    local ft = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
                    return not require('user.tool-windows').is_tool_ft(ft)
                end,
                on_attach = on_attach,
                sources = {
                    -- code actions
                    null_ls.builtins.code_actions.shellcheck,
                    null_ls.builtins.code_actions.gitrebase,

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
                },
            }

            -- TODO: verify what's needed, languages: Lua, TS, Rust, Markdown
        end,
    },
}
