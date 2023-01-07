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

function M.telescope_select_and_run(filter, command)
    local actions = require('telescope.actions')
    local state = require('telescope.actions.state')
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values

    local opts = { find_command = { 'find', '.', '-name', filter } }
    local function _confirm(prompt_bufnr)
        local selection = state.get_selected_entry()
        if selection == nil then
            return
        end
        actions.close(prompt_bufnr)
        vim.cmd(command..' '..selection[1])
    end

    pickers.new(opts, {
        prompt_title = 'Select Project',
        finder = finders.new_oneshot_job(opts.find_command, opts),
        previewer = conf.file_previewer(opts),
        sorter = conf.file_sorter(opts),
        attach_mappings = function(_, map)
            map('i', '<CR>', _confirm)
            map('n', '<CR>', _confirm)
            return true
        end,
    }):find()
end

return M

