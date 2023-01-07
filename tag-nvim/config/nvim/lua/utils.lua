local M = {}

function M.which_key_leader(spec, opts)
    opts = opts or { prefix = '<Leader>' }
    require('which-key').register(spec, opts)
end

M.nmap = function(k, v, opts) vim.api.nvim_set_keymap('n', k, v, opts or {noremap=true, silent=true}) end
M.imap = function(k, v, opts) vim.api.nvim_set_keymap('i', k, v, opts or {noremap=true, silent=true}) end
M.vmap = function(k, v, opts) vim.api.nvim_set_keymap('v', k, v, opts or {noremap=true, silent=true}) end
M.xmap = function(k, v, opts) vim.api.nvim_set_keymap('x', k, v, opts or {noremap=true, silent=true}) end
M.omap = function(k, v, opts) vim.api.nvim_set_keymap('o', k, v, opts or {noremap=true, silent=true}) end

M.defcmd = function(lhs, rhs, opts) vim.api.nvim_create_user_command(lhs, rhs, opts or { force = true }) end

function M.exec_cmd(cmd)
    local output = vim.fn.system(cmd)
    if vim.v.shell_error == 0 then
        return output
    end
    return nil
end

return M

