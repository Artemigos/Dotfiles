-- mason name -> lspconfig name
local supported_servers = {
    ['bash-language-server'] = 'bashls',
    ['rust-analyzer'] = 'rust_analyzer',
    ['json-lsp'] = 'jsonls',
    ['lua-language-server'] = 'lua_ls',
    ['pyright'] = 'pyright',
    ['vim-language-server'] = 'vimls',
    ['yaml-language-server'] = 'yamlls',
    ['css-lsp'] = 'cssls',
    ['typescript-language-server'] = 'ts_ls',
    ['ruff'] = 'ruff',
    ['gopls'] = 'gopls',
    ['marksman'] = 'marksman',
    ['terraform-ls'] = 'terraformls',
    ['zls'] = 'zls',
}

local auto_install_tools = {
    -- DAPs
    'bash-debug-adapter',
    'codelldb',
    'go-debug-adapter',
    'js-debug-adapter',
    -- linters
    'shellcheck',
    -- formatters
    'isort',
    'black',
    'gofumpt',
    'shfmt',
    'terraform',
}

local function hover()
    vim.lsp.buf.hover({
        border = 'rounded',
    })
end

local function signature_help()
    vim.lsp.buf.signature_help({
        border = 'rounded',
    })
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
            local all_tools = {}
            vim.list_extend(all_tools, auto_install_tools)
            vim.list_extend(all_tools, vim.tbl_keys(supported_servers))
            for _, tool in ipairs(all_tools) do
                if not reg.is_installed(tool) then
                    local ok, pkg = pcall(reg.get_package, tool)
                    if ok then
                        vim.notify('[Mason] Installing ' .. tool .. '...', vim.log.levels.INFO)
                        pkg:install()
                    else
                        vim.notify('[Mason] Unknown tool: ' .. tool, vim.log.levels.WARN)
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
            'saghen/blink.cmp',
        },
        keys = {
            { 'gd',       vim.lsp.buf.definition,     desc = 'Go to definition' },
            { 'gD',       vim.lsp.buf.implementation, desc = 'Go to implementation' },
            { 'gr',       vim.lsp.buf.references,     desc = 'References' },
            { 'g<Space>', hover,                      desc = 'Hint' },
            {
                'ga',
                vim.lsp.buf.code_action,
                mode = { 'n', 'v' },
                desc = 'Show code actions'
            },
            { 'gt',               vim.lsp.buf.type_definition,                    desc = 'Go to type definition' },
            { '<C-Space>',        signature_help,                                 desc = 'Signature help' },
            { 'gT',               ':Telescope lsp_dynamic_workspace_symbols<CR>', desc = 'Workspace symbols' },
            { 'gX',               ':Telescope diagnostics<CR>',                   desc = 'Diagnostics' },
            { 'gA',               ':ToggleAutoFormat<CR>',                        desc = 'Toggle auto formatting' },
            { '<Leader>cd',       vim.lsp.buf.definition,                         desc = 'Go to definition' },
            { '<Leader>cD',       vim.lsp.buf.implementation,                     desc = 'Go to implementation' },
            { '<Leader>cr',       vim.lsp.buf.references,                         desc = 'References' },
            { '<Leader>c<Space>', hover,                                          desc = 'Hint' },
            {
                '<Leader>ca',
                vim.lsp.buf.code_action,
                mode = { 'n', 'v' },
                desc = 'Show code actions'
            },
            { '<Leader>ct', vim.lsp.buf.type_definition,                    desc = 'Go to type definition' },
            { '<Leader>cT', ':Telescope lsp_dynamic_workspace_symbols<CR>', desc = 'Workspace symbols' },
            { '<Leader>cX', ':Telescope diagnostics<CR>',                   desc = 'Diagnostics' },
            { '<Leader>cA', ':ToggleAutoFormat<CR>',                        desc = 'Toggle auto formatting' },
            { '<Leader>rr', vim.lsp.buf.rename,                             desc = 'Rename' },
        },
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
                callback = function(event)
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client:supports_method('textDocument/inlayHint', event.buf) then
                        local inlays = vim.lsp.inlay_hint
                        inlays.enable(true)
                        vim.keymap.set(
                            'n',
                            '<Leader>i',
                            function()
                                inlays.enable(not inlays.is_enabled({ bufnr = event.buf }))
                            end,
                            { desc = 'Toggle inlay hints' }
                        )
                    end
                end,
            })

            vim.lsp.config('*', {
                capabilities = require('blink.cmp').get_lsp_capabilities(),
            })

            local runtime_path = vim.split(package.path, ';')
            table.insert(runtime_path, "lua/?.lua")
            table.insert(runtime_path, "lua/?/init.lua")

            vim.lsp.config('lua_ls', {
                settings = {
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
            })

            for _, server in pairs(supported_servers) do
                vim.lsp.enable(server)
            end

            require('lspconfig.ui.windows').default_options.border = 'rounded'
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
                typescript = { 'prettier' },
                javascript = { 'prettier' },
                vcl = { 'vcl_formatter' },
                alloy = { 'alloy_fmt' },
                terraform = { 'terraform_fmt' },
            },
            formatters = {
                vcl_formatter = {
                    command = 'vcl-formatter',
                    args = function(_, ctx)
                        return { '-i', tostring(ctx.shiftwidth), '-' }
                    end,
                    stdin = true,
                },
                alloy_fmt = {
                    command = 'alloy',
                    args = { 'fmt', '-' },
                    stdin = true,
                },
            },
        },
        init = function()
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
    },
}
