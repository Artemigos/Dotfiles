local M = {
    lualine_mode = true,
}

local function stl_hi(name)
    return '%#' .. name .. '#'
end

local pad = ' '
local stl_hi_rst = '%*'

local function stl_content(content)
    return pad .. content .. pad
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
    return stl_hi(M.hi_for_mode(m)) .. stl_content(r) .. stl_hi_rst
end

function M.wrap(f)
    return { '%{%luaeval("line.' .. f .. '()")%}', padding = 0 }
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

    if not M.lualine_mode then
        vim.opt.showtabline = 0
        vim.opt.laststatus = 3
        vim.opt.statusline = '%{%luaeval("line.mode()")%}'

        vim.api.nvim_create_autocmd('ModeChanged', { command = 'redrawstatus' })
    end
end

return M
