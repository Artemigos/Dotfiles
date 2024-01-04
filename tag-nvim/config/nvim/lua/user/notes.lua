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
    vim.api.nvim_win_set_cursor(0, { 2, 0 })
end

function M.create_dated_note(dir, title)
    local date_str = os.date('%Y.%m.%d')
    local file = date_str .. ' ' .. title .. '.md'
    M.create_note(dir, title, file)
end

function M.find_link_text_under_cursor()
    local node = vim.treesitter.get_node({ ignore_injections = false })
    while node ~= nil and node:type() ~= 'link_text' do
        node = node:parent()
    end

    if node ~= nil then
        return vim.treesitter.get_node_text(node, 0)
    end

    return nil
end

function M.ui_new_note(dir, default)
    local opts = { prompt = 'Name' }
    if default ~= nil then
        opts.default = default
    end
    local function on_confirm(title)
        if title == nil then
            return
        end
        M.create_note(dir, title)
    end
    vim.ui.input(opts, on_confirm)
end

function M.ui_new_dated_note(dir, default)
    local opts = { prompt = 'Title' }
    if default ~= nil then
        opts.default = default
    end
    local function on_confirm(title)
        if title == nil then
            return
        end
        M.create_dated_note(dir, title)
    end
    vim.ui.input(opts, on_confirm)
end

return M
