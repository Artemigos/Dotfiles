local M = {}

function M.map(mode, lhs, rhs, opts)
    opts = vim.tbl_extend('force', { silent = true }, opts or {})
    vim.keymap.set(mode, lhs, rhs, opts)
end

function M.defcmd(lhs, rhs, opts)
    opts = vim.tbl_extend('force', { force = true }, opts or {})
    vim.api.nvim_create_user_command(lhs, rhs, opts)
end

function M.try_exec(cmd)
    local output = vim.fn.system(cmd)
    return vim.v.shell_error, output
end

function M.exec(cmd)
    local code, output = M.try_exec(cmd)
    if code == 0 then
        return output
    end
    error('Command "' .. cmd .. '" exited with code ' .. code)
end

function M.select_file_and_run(filter, handler)
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
        handler(selection[1])
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
