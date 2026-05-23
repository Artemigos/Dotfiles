local M = {}

function M.stl_hi(name, inherit)
    if inherit == true then
        return '%$' .. name .. '$'
    end
    return '%#' .. name .. '#'
end

---@param func_name string
---@param text string
---@param arg any?
local function stl_click(func_name, text, arg)
    local arg_str = ''
    if arg ~= nil then
        arg_str = tostring(arg)
    end
    return '%' .. arg_str .. '@v:lua.line.' .. func_name .. '@' .. text .. '%X'
end
local function pad(c)
    if c == '' then return '' end
    return ' ' .. c .. ' '
end
local sep = '%='
local hi1 = M.stl_hi('LinePrimary')
local hi2 = M.stl_hi('LineSecondary')
local hi3 = M.stl_hi('LineTertiary')

function M.hi_for_mode(mode)
    local m = mode or vim.api.nvim_get_mode().mode
    local c = string.sub(m, 1, 1)
    if c == '' or c == 'V' or c == 'v' then
        return 'LineModeVisual'
    elseif c == 'n' then
        return 'LineModeNormal'
    elseif c == 'i' then
        return 'LineModeInsert'
    elseif c == 'R' then
        return 'LineModeReplace'
    elseif c == 'c' then
        return 'LineModeCommand'
    else
        return 'LineModeCommand'
    end
end

function M.mode()
    local m = vim.api.nvim_get_mode().mode
    local c = string.sub(m, 1, 1)
    local r = string.upper(c)
    if c == '' then
        r = 'VB'
    elseif c == 'V' then
        r = 'VL'
    end
    return r
end

function M.location()
    local line = '%3.l'
    local column = '%-2.c'
    return line .. ':' .. column
end

function M.progress()
    return '%p%%'
end

function M.filetype(hi_parent)
    local ft = vim.o.filetype
    if ft == '' then
        return ''
    end
    local icon, hl = MiniIcons.get('filetype', ft)
    return M.stl_hi(hl, true) .. icon .. hi_parent .. ' ' .. ft
end

function M.fileformat()
    ---@type string
    local os = vim.o.fileformat
    if os == '' then
        return ''
    end
    if os == 'unix' then
        return '␊'
    elseif os == 'dos' then
        return '␍␊'
    elseif os == 'mac' then
        return '␍'
    else
        error('unknown fileformat: ' .. os)
    end
end

function M.encoding()
    return vim.o.encoding
end

function M.filename()
    return '%t %m%r'
end

local function git(...)
    local out = require('user.utils').try_exec({ 'git', ... })
    if out.code ~= 0 then
        return nil
    end
    return out.output:gsub('%s+$', '')
end

function M.ref()
    local branch = git('rev-parse', '--abbrev-ref', 'HEAD')
    if branch == nil then
        return ''
    end
    if branch == 'HEAD' then
        branch = git('rev-parse', '--short=6', 'HEAD')
    end
    return ' ' .. branch
end

function M.diagnostics()
    local stats = vim.diagnostic.status()
    if stats == '' then
        return ''
    end
    -- HACK: neovim unconditionally appends "%##" at the end of non-empty format, which I don't want
    assert(stats:sub(-3) == '%##', 'Assumption for a [HACK] broken')
    return stats:sub(1, -4)
end

local function toggle_icon(icon, is_on, action_f_name)
    local txt = icon
    if is_on() then
        txt = M.stl_hi('LineToggleOn', true) .. txt .. M.stl_hi('LineTertiary')
    else
        txt = M.stl_hi('LineToggleOff', true) .. txt .. M.stl_hi('LineTertiary')
    end
    return stl_click(action_f_name, txt)
end

function M.auto_format_action()
    require('user.auto-format').toggle()
    vim.cmd.redrawstatus()
end

function M.auto_format()
    return toggle_icon(
        '',
        require('user.auto-format').is_enabled,
        'auto_format_action'
    )
end

function M.toggle_diagnostics_action()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    vim.cmd.redrawstatus()
end

function M.toggle_diagnostics()
    return toggle_icon(
        '󰚔',
        vim.diagnostic.is_enabled,
        'toggle_diagnostics_action'
    )
end

function M.full_line()
    local m = vim.api.nvim_get_mode().mode
    local hi_mode = M.stl_hi(M.hi_for_mode(m))

    return
        hi_mode ..
        pad(M.mode()) ..
        hi2 ..
        pad(M.ref()) ..
        pad(M.diagnostics()) ..
        hi3 ..
        pad(M.filename()) ..
        sep ..
        pad(M.auto_format()) ..
        pad(M.toggle_diagnostics()) ..
        pad(M.encoding()) ..
        pad(M.fileformat()) ..
        pad(M.filetype(hi3)) ..
        hi2 ..
        pad(M.progress()) ..
        hi_mode ..
        pad(M.location())
end

function M.pick_winbar(_)
    local buf_id = vim.api.nvim_get_current_buf()
    local ft = vim.bo[buf_id].filetype
    local win_id = vim.api.nvim_get_current_win()
    local wo = vim.wo[win_id]
    local config = vim.api.nvim_win_get_config(win_id)

    -- skip floating windows
    if config.anchor ~= nil then
        return
    end

    -- ignored filetypes
    local ignore = {
        'dap-repl',
        'dapui_console',
        'dapui_watches',
        'dapui_stacks',
        'dapui_breakpoints',
        'dapui_scopes',
        'gitcommit',
    }
    if vim.tbl_contains(ignore, ft) then
        return
    end

    -- tool windows
    local tw = require('user.tool-windows')
    if vim.tbl_contains(tw.get_filetypes(), ft) then
        wo.winbar = hi3 .. sep .. tw.get_title(ft) .. sep
        return
    end

    -- help buffers
    if ft == 'help' then
        local match = vim.api.nvim_buf_get_name(buf_id):match('([^/]+)$') or '?'
        wo.winbar = hi3 .. sep .. 'Help: ' .. match .. sep
        return
    end

    wo.winbar = '%{%luaeval("line.default_winbar()")%}'
end

function M.buffer_action(num)
    vim.api.nvim_set_current_buf(num)
end

function M.buffers()
    local buffers = ''

    local buf_ids = vim.api.nvim_list_bufs()
    local curr = vim.api.nvim_get_current_buf()
    for _, buf_id in ipairs(buf_ids) do
        local loaded = vim.api.nvim_buf_is_loaded(buf_id)
        local listed = vim.bo[buf_id].buflisted
        if loaded and listed then
            if buf_id == curr then
                buffers = buffers .. hi1
            else
                buffers = buffers .. hi3
            end
            local name = vim.api.nvim_buf_get_name(buf_id)
            if name == '' then
                name = '[No name]'
            else
                local ft = vim.bo[buf_id].filetype
                local icon = MiniIcons.get('filetype', ft)
                local match = name:match('([^/]+)$') or ft
                name = icon .. ' ' .. match
            end
            if vim.bo[buf_id].modified then
                name = name .. ' ●'
            end
            name = pad(name)
            buffers = buffers .. stl_click('buffer_action', name, buf_id)
        end
    end
    buffers = buffers .. hi3
    return buffers
end

function M.tab_action(num)
    vim.api.nvim_set_current_tabpage(num)
end

function M.tabs()
    local tabs = ''

    local tab_ids = vim.api.nvim_list_tabpages()
    local curr_tab = vim.api.nvim_get_current_tabpage()
    if #tab_ids > 1 then
        for _, tab_id in ipairs(tab_ids) do
            if tab_id == curr_tab then
                tabs = tabs .. hi1
            else
                tabs = tabs .. hi3
            end
            local tab_name = pad(tostring(tab_id))
            tabs = tabs .. stl_click('tab_action', tab_name, tab_id)
        end
    end

    return tabs
end

function M.default_winbar()
    local tabs = M.tabs()
    local buffers = M.buffers()
    return buffers .. sep .. tabs
end

function M.setup()
    _G.line = M

    local g = vim.api.nvim_create_augroup('user.line', {})

    -- highlights
    local colors = require('dracula').colors()
    vim.cmd.hi('LineModeNormal', 'guibg=' .. colors.purple, 'guifg=' .. colors.black, 'gui=bold')
    vim.cmd.hi('LineModeInsert', 'guibg=' .. colors.green, 'guifg=' .. colors.black, 'gui=bold')
    vim.cmd.hi('LineModeVisual', 'guibg=' .. colors.yellow, 'guifg=' .. colors.black, 'gui=bold')
    vim.cmd.hi('LineModeReplace', 'guibg=' .. colors.red, 'guifg=' .. colors.black, 'gui=bold')
    vim.cmd.hi('LineModeCommand', 'guibg=' .. colors.orange, 'guifg=' .. colors.black, 'gui=bold')
    vim.cmd.hi('LinePrimary', 'guibg=' .. colors.purple, 'guifg=' .. colors.black)
    vim.cmd.hi('LineSecondary', 'guibg=' .. colors.comment, 'guifg=' .. colors.fg)
    vim.cmd.hi('LineTertiary', 'guibg=' .. colors.selection, 'guifg=' .. colors.fg)
    vim.cmd.hi('LineToggleOn', 'guifg=' .. colors.green)
    vim.cmd.hi('LineToggleOff', 'guifg=' .. colors.comment)

    -- statusline
    vim.opt.showtabline = 0
    vim.opt.laststatus = 3
    vim.opt.statusline = '%{%luaeval("line.full_line()")%}'

    -- winbar
    vim.go.winbar = ''
    vim.api.nvim_create_autocmd({ 'FileType', 'BufWinEnter', 'BufNew' }, {
        group = g,
        callback = M.pick_winbar,
    })

    -- redraw triggers
    local function redraw()
        vim.schedule(vim.cmd.redrawstatus)
    end
    vim.api.nvim_create_autocmd('ModeChanged', {
        group = g,
        callback = redraw,
    })
    M.timer = vim.uv.new_timer()
    M.timer:start(1000, 1000, redraw)
end

return M
