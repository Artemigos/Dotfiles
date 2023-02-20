local u = require('user.utils')
local null_ls = require('null-ls')
local formatter_factory = require('null-ls.helpers').formatter_factory

local yq = {
    name = 'yq',
    method = null_ls.methods.FORMATTING,
    generator = formatter_factory({ command = 'yq', to_stdin = true, }),
    filetypes = { 'yaml' },
}

null_ls.setup({
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
})

require('mason-null-ls').setup({
    ensure_installed = nil,
    automatic_installation = true,
    automatic_setup = false,
})

u.map('n', 'gF', '<cmd>Format<CR>')
u.map('n', '<leader>cF', '<cmd>Format<CR>')

-- TODO: verify what's needed, languages: Lua, TS, Rust, Markdown
