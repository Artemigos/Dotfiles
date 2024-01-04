local M = {}

function M.create_note(dir, title, file)
    file = file or (title .. '.md')
    local path = dir .. '/' .. file

    local lines = {
        '# ' .. title,
        '',
    }

    vim.cmd('edit ' .. vim.fn.fnameescape(path))
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.api.nvim_win_set_cursor(0, {2, 0})
end

function M.create_dated_note(dir, title)
    local date_str = os.date('%Y.%m.%d')
    local file = date_str .. ' ' .. title .. '.md'
    M.create_note(dir, title, file)
end

function M.ui_new_note(dir)
    vim.ui.input({ prompt = 'Title' }, function(title) M.create_note(dir, title) end)
end

function M.ui_new_dated_note(dir)
    vim.ui.input({ prompt = 'Title' }, function(title) M.create_dated_note(dir, title) end)
end

return M
