local M = {};

M.config = {
    todo_deselected_prefix = '[ ] ',
    todo_selected_prefix = '[x] ',
    auto_convert = false,
}

local function configure_todo()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.expandtab = true

    vim.keymap.set({'n', 'v'}, '<CR>', ':ToggleTodo<CR>', {
        silent = true,
        buffer = true,
    })
end

local function escape_for_regex(str)
    return vim.fn.escape(str, '^$.*?/\\[]')
end

local function matches_prefix(str, prefix)
    local escaped = escape_for_regex(prefix)
    return vim.fn.match(str, '^\\s*' .. escaped .. '.*') ~= -1
end

local function swap_prefix(line, current_prefix, new_prefix)
    local pattern = '^\\(\\s*\\)' .. escape_for_regex(current_prefix)
    return vim.fn.substitute(line, pattern, '\\1' .. new_prefix, '')
end

local function add_prefix(line, new_prefix)
    return vim.fn.substitute(line, '^\\(\\s*\\)', '\\1' .. new_prefix, '')
end

function M.toggle_todo(line)
    if matches_prefix(line, M.config.todo_deselected_prefix) then
        return swap_prefix(line, M.config.todo_deselected_prefix, M.config.todo_selected_prefix)
    elseif matches_prefix(line, M.config.todo_selected_prefix) then
        return swap_prefix(line, M.config.todo_selected_prefix, M.config.todo_deselected_prefix)
    elseif M.config.auto_convert then
        return add_prefix(line, M.config.todo_deselected_prefix)
    else
        vim.notify('No TODO item on current line.', vim.log.levels.INFO)
        return
    end
end

function M.setup(config)
    M.config = vim.tbl_extend('force', M.config, config or {})
    vim.api.nvim_create_augroup('todo_mappings', { clear = true })
    vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
        group = 'todo_mappings',
        pattern = 'todo.txt',
        callback = configure_todo,
    })
    vim.api.nvim_create_user_command(
        'ToggleTodo',
        ':silent <line1>,<line2>luado return require("todo").toggle_todo(line)<CR>',
        { range = true })
end

return M
