local null_ls = require('null-ls')
local formatter_factory = require('null-ls.helpers').formatter_factory

local yq = {
    name = 'yq',
    method = null_ls.methods.FORMATTING,
    generator = formatter_factory({ command = 'yq', to_stdin = true, }),
    filetypes = { 'yaml' },
}

null_ls.setup({
    sources = {
        -- code actions
        null_ls.builtins.code_actions.shellcheck,
        null_ls.builtins.code_actions.gitrebase,
        -- null_ls.builtins.code_actions.eslint,
        -- null_ls.builtins.code_actions.refactoring,

        -- diagnostics
        null_ls.builtins.diagnostics.editorconfig_checker,
        null_ls.builtins.diagnostics.fish,
        -- null_ls.builtins.diagnostics.eslint,
        -- null_ls.builtins.diagnostics.hadolint,
        -- null_ls.builtins.diagnostics.markdownlint,
        -- null_ls.builtins.diagnostics.mypy,
        -- null_ls.builtins.diagnostics.selene,
        -- null_ls.builtins.diagnostics.yamllint,

        -- formatters
        null_ls.builtins.formatting.fish_indent,
        null_ls.builtins.formatting.shfmt,
        yq,
        -- null_ls.builtins.formatting.prettierd,
        -- null_ls.builtins.formatting.lua_format,
        -- null_ls.builtins.formatting.markdownlint,
        -- null_ls.builtins.formatting.rustfmt,
    },
})

require('mason-null-ls').setup({
    ensure_installed = nil,
    automatic_installation = true,
    automatic_setup = false,
})

local u = require('utils')
u.nmap('gF', '<cmd>Format<CR>')
u.nmap('<leader>cF', '<cmd>Format<CR>')

-- TODO: verify that needed, languages: Lua, Python, TS, Rust
