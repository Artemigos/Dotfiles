local M = {
    lualine_mode = true,
    padding = ' ',
    hi_secondary = 'LineSecondary',
    hi_tertiary = 'LineTertiary',
}

M.stl = {
    hi_rst = '%*',
    sep = '%=',
    items = {
        line = 'l',
        column = 'c',
        progress = 'p',
    },
}

function M.stl.hi(name, inherit)
    if inherit == true then
        return '%$' .. name .. '$'
    end
    return '%#' .. name .. '#'
end

function M.stl.content(content)
    return M.padding .. content .. M.padding
end

function M.stl.leval(f)
    return '%{%luaeval("line.' .. f .. '()")%}'
end

function M.stl.item(item, opts)
    opts = opts or {}
    local r = '%'
    if opts.leftpad == true then
        r = r .. '-'
    end
    if opts.zeropad == true then
        r = r .. '0'
    end
    if opts.minwidth ~= nil then
        assert(type(opts.minwidth) == 'number', 'minwidth must be a number')
        r = r .. opts.minwidth
    end
    if opts.minwidth ~= nil or opts.maxwidth ~= nil then
        r = r .. '.'
    end
    if opts.maxwidth ~= nil then
        assert(type(opts.maxwidth) == 'number', 'maxwidth must be a number')
        r = r .. opts.maxwidth
    end
    return r .. item
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
    elseif c == 'v' then
        r = 'V'
    elseif c == 'n' then
        r = 'N'
    elseif c == 'i' then
        r = 'I'
    elseif c == 'R' then
        r = 'R'
    elseif c == 'c' then
        r = 'C'
    end
    return M.stl.hi(M.hi_for_mode(m)) .. M.stl.content(r) .. M.stl.hi_rst
end

function M.location()
    local m = vim.api.nvim_get_mode().mode
    local line = M.stl.item(M.stl.items.line, { minwidth = 3 })
    local column = M.stl.item(M.stl.items.column, { minwidth = 2, leftpad = true })
    local r = line .. ':' .. column
    return M.stl.hi(M.hi_for_mode(m)) .. M.stl.content(r) .. M.stl.hi_rst
end

function M.progress()
    local progress = M.stl.item(M.stl.items.progress) .. '%%'
    return M.stl.hi(M.hi_secondary) .. M.stl.content(progress) .. M.stl.hi_rst
end

function M.filetype()
    local ft = vim.o.filetype
    if ft == '' then
        return ''
    end
    local icon, hl = MiniIcons.get('filetype', ft)
    local trt = M.stl.hi(M.hi_tertiary)
    local r = M.stl.hi(hl, true) .. icon .. trt .. ' ' .. ft
    return trt .. M.stl.content(r) .. M.stl.hi_rst
end

function M.fileformat()
    ---@type string
    local os = vim.o.fileformat
    if os == '' then
        return ''
    end
    if os == 'unix' then
        os = 'linux'
    elseif os == 'dos' then
        os = 'windows'
    elseif os == 'mac' then
        os = 'macos'
    else
        error('unknown fileformat: ' .. os)
    end
    local icon = MiniIcons.get('os', os)
    return M.stl.hi(M.hi_tertiary) .. M.stl.content(icon) .. M.stl.hi_rst
end

function M.wrap(f)
    return { M.stl.leval(f), padding = 0 }
end

function M.full_line()
    return M.mode() .. M.stl.sep .. M.fileformat() .. M.filetype() .. M.progress() .. M.location()
end

-- WIP:
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
        vim.opt.statusline = M.stl.leval('full_line')

        vim.api.nvim_create_autocmd('ModeChanged', { command = 'redrawstatus' })
    end
end

return M
