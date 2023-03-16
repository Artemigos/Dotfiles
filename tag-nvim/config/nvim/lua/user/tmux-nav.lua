local M = {}

local u = require('user.utils')

local function tmux_exec(args)
    local socket = vim.split(vim.env['TMUX'], ',')[1]
    return u.exec('tmux -S ' .. socket .. ' ' .. args)
end

local function is_tmux_zoomed()
    return tonumber(tmux_exec("display-message -p '#{window_zoomed_flag}'")) == 1
end

local function try_navigate_window(direction)
    local nr = vim.fn.winnr()
    vim.cmd('wincmd ' .. direction)
    return (nr ~= vim.fn.winnr())
end

function M.navigate(direction)
    local navigated = try_navigate_window(direction)
    if not is_tmux_zoomed() and not navigated then
        tmux_exec(
            'select-pane -t '
            .. vim.fn.shellescape(vim.env['TMUX_PANE'])
            .. ' -'
            .. vim.fn.tr(direction, 'hjkl', 'LDUR'))
    end
end

function M.setup()
    u.map('n', '<C-h>', function() M.navigate('h') end)
    u.map('n', '<C-j>', function() M.navigate('j') end)
    u.map('n', '<C-k>', function() M.navigate('k') end)
    u.map('n', '<C-l>', function() M.navigate('l') end)
end

return M
