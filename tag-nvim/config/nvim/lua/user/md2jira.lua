local u = require('user.utils')

---not a complete converter, just what's useful for me
local function convertMdToJson()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local result = ''
    local in_code = false
    for _, value in ipairs(lines) do
        if vim.startswith(value, '```') then
            if string.len(value) > 3 then
                value = '{code:' .. string.sub(value, 4) .. '}'
            else
                value = '{code}'
            end
            in_code = not in_code
        elseif not in_code then
            if vim.startswith(value, '# ') then
                value = 'h1. ' .. string.sub(value, 3)
            elseif vim.startswith(value, '## ') then
                value = 'h2. ' .. string.sub(value, 4)
            elseif vim.startswith(value, '### ') then
                value = 'h3. ' .. string.sub(value, 5)
            elseif vim.startswith(value, '#### ') then
                value = 'h4. ' .. string.sub(value, 6)
            elseif vim.startswith(value, '##### ') then
                value = 'h5. ' .. string.sub(value, 7)
            elseif vim.startswith(value, '###### ') then
                value = 'h6. ' .. string.sub(value, 8)
            end

            local last_start = nil
            local last_found = 0
            while true do
                local s, _ = string.find(value, '`', last_found+1, true)
                if s == nil then
                    break
                end

                last_found = s
                if last_start == nil then
                    last_start = s
                else
                    value = string.sub(value, 1, s-1) .. '}}' .. string.sub(value, s+1)
                    value = string.sub(value, 1, last_start-1) .. '{{' .. string.sub(value, last_start+1)
                    last_start = nil
                end
            end
        end
        result = result .. value .. '\n'
    end
    vim.fn.setreg('+', result)
end

local M = {}

function M.setup()
    u.defcmd('Md2JiraClipboard', convertMdToJson)
end

return M
