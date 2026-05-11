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

function M.wrap(f, ...)
    local varargs = vim.iter({ ... }):map(function(x) return "'" .. x .. "'" end):join(',')
    local extra_pad = ''
    -- why?
    if f == 'mode' then
        extra_pad = ' .. line.padding'
    end
    local eval = '%{%luaeval("line.padding' .. extra_pad .. ' .. line.' .. f .. '(' .. varargs .. ') .. line.padding")%}'
    return { eval, padding = 0 }
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

    -- WIP:
    return
        hi1 .. pad(M.mode()) ..
        hi3 .. pad(M.filename()) ..
        sep ..
        pad(M.encoding()) .. pad(M.fileformat()) .. pad(M.filetype(hi3)) ..
        hi2 .. pad(M.progress()) ..
        hi1 .. pad(M.location())
end

-- TODO: winbar
function M.setup(lualine)
    M.lualine_mode = not not lualine

    _G.line = M

    local colors = require('dracula').colors()
    vim.cmd.hi('LineModeNormal', 'guibg=' .. colors.purple, 'guifg=' .. colors.black, 'gui=bold')
    vim.cmd.hi('LineModeInsert', 'guibg=' .. colors.green, 'guifg=' .. colors.black, 'gui=bold')
    vim.cmd.hi('LineModeVisual', 'guibg=' .. colors.yellow, 'guifg=' .. colors.black, 'gui=bold')
    vim.cmd.hi('LineModeReplace', 'guibg=' .. colors.red, 'guifg=' .. colors.black, 'gui=bold')
    vim.cmd.hi('LineModeCommand', 'guibg=' .. colors.orange, 'guifg=' .. colors.black, 'gui=bold')
    vim.cmd.hi('LineSecondary', 'guibg=' .. colors.comment, 'guifg=' .. colors.fg)
    vim.cmd.hi('LineTertiary', 'guifg=' .. colors.fg)

    if not M.lualine_mode then
        vim.opt.showtabline = 0
        vim.opt.laststatus = 3
        vim.opt.statusline = '%{%luaeval("line.full_line()")%}'

        vim.api.nvim_create_autocmd('ModeChanged', { command = 'redrawstatus' })
    end
end

return M
