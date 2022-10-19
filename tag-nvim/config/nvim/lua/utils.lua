function _G.which_key_leader(spec, opts)
    opts = opts or { prefix = '<Leader>' }
    require('which-key').register(spec, opts)
end

_G.nmap = function(k, v, opts) vim.api.nvim_set_keymap('n', k, v, opts or {noremap=true, silent=true}) end
_G.imap = function(k, v, opts) vim.api.nvim_set_keymap('i', k, v, opts or {noremap=true, silent=true}) end
_G.vmap = function(k, v, opts) vim.api.nvim_set_keymap('v', k, v, opts or {noremap=true, silent=true}) end
_G.xmap = function(k, v, opts) vim.api.nvim_set_keymap('x', k, v, opts or {noremap=true, silent=true}) end
_G.omap = function(k, v, opts) vim.api.nvim_set_keymap('o', k, v, opts or {noremap=true, silent=true}) end

_G.defcmd = function(lhs, rhs, opts) vim.api.nvim_create_user_command(lhs, rhs, opts or { force = true }) end
