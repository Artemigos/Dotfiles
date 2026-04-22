vim.pack.add({
    'https://github.com/williamboman/mason.nvim',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/stevearc/conform.nvim',
})

local u = require('user.utils')

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

-- mason.nvim
require('mason').setup({
    ui = {
        border = 'rounded',
    },
})
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

-- nvim-lspconfig
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

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set('n', 'gD', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'References' })
vim.keymap.set('n', 'g<Space>', hover, { desc = 'Hint' })
vim.keymap.set({ 'n', 'v' }, 'ga', vim.lsp.buf.code_action, { desc = 'Show code actions' })
vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, { desc = 'Go to type definition' })
vim.keymap.set('n', '<C-Space>', signature_help, { desc = 'Signature help' })
vim.keymap.set('n', 'gT', u.lazy_pick.lsp_workspace_symbols, { desc = 'Workspace symbols' })
vim.keymap.set('n', 'gX', u.lazy_pick.diagnostics, { desc = 'Diagnostics' })
vim.keymap.set('n', 'gA', ':ToggleAutoFormat<CR>', { desc = 'Toggle auto formatting' })
vim.keymap.set('n', '<Leader>cd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set('n', '<Leader>cD', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
vim.keymap.set('n', '<Leader>cr', vim.lsp.buf.references, { desc = 'References' })
vim.keymap.set('n', '<Leader>c<Space>', hover, { desc = 'Hint' })
vim.keymap.set({ 'n', 'v' }, '<Leader>ca', vim.lsp.buf.code_action, { desc = 'Show code actions' })
vim.keymap.set('n', '<Leader>ct', vim.lsp.buf.type_definition, { desc = 'Go to type definition' })
vim.keymap.set('n', '<Leader>cT', u.lazy_pick.lsp_workspace_symbols, { desc = 'Workspace symbols' })
vim.keymap.set('n', '<Leader>cX', u.lazy_pick.diagnostics, { desc = 'Diagnostics' })
vim.keymap.set('n', '<Leader>cA', ':ToggleAutoFormat<CR>', { desc = 'Toggle auto formatting' })
vim.keymap.set('n', '<Leader>rr', vim.lsp.buf.rename, { desc = 'Rename' })

-- conform.nvim
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
require('conform').setup({
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
})

vim.keymap.set('n', 'gF', '<cmd>Format<CR>', { desc = 'Format code' })
vim.keymap.set('n', '<leader>cF', '<cmd>Format<CR>', { desc = 'Format code' })
