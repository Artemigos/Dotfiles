local M = {
    lualine_mode = true,
    padding = ' ',
}

function M.stl_hi(name, inherit)
    if inherit == true then
        return '%$' .. name .. '$'
    end
    return '%#' .. name .. '#'
end

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
    return require('user.utils').exec({ 'git', ... }):gsub('%s+$', '')
end

function M.ref()
    local branch = git('rev-parse', '--abbrev-ref', 'HEAD')
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
    return '%@v:lua.line.' .. action_f_name .. '@' .. txt .. '%X'
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
    local hi1 = M.stl_hi(M.hi_for_mode(m))
    local hi2 = M.stl_hi('LineSecondary')
    local hi3 = M.stl_hi('LineTertiary')
    local sep = '%='
    local function pad(c)
        if c == '' then return '' end
        return M.padding .. c .. M.padding
    end

    return
        hi1 ..
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
        hi1 ..
        pad(M.location())
end

function M.default_winbar()
    local hi1 = M.stl_hi('LinePrimary')
    local hi3 = M.stl_hi('LineTertiary')
    local sep = '%='
    local buffers = ''
    local tabs = ''

    -- buffers
    -- TODO: clickable
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
            buffers = buffers .. M.padding .. name .. M.padding
        end
    end
    buffers = buffers .. hi3

    -- tabs
    -- TODO: clickable
    local tab_ids = vim.api.nvim_list_tabpages()
    local curr_tab = vim.api.nvim_get_current_tabpage()
    if #tab_ids > 1 then
        for _, tab_id in ipairs(tab_ids) do
            if tab_id == curr_tab then
                tabs = tabs .. hi1
            else
                tabs = tabs .. hi3
            end
            tabs = tabs .. M.padding .. tostring(tab_id) .. M.padding
        end
    end

    return buffers .. sep .. tabs
end

function M.setup(lualine)
    M.lualine_mode = not not lualine

    _G.line = M

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

    vim.opt.showtabline = 0
    vim.opt.laststatus = 3
    vim.opt.statusline = '%{%luaeval("line.full_line()")%}'

    local g = vim.api.nvim_create_augroup('user.line', {})

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

    if not M.lualine_mode then
        vim.go.winbar = '%{%luaeval("line.default_winbar()")%}'
    end
end

return M
