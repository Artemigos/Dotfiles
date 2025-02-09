local M = {
    config = {},
}

function M.load()
    local data = require('user.utils').exec('d config cat-json')
    M.config = vim.json.decode(data)
    return M.config
end

function M.get(path, default)
    local cur = M.config
    for _, segment in ipairs(path) do
        cur = cur[segment]
        if cur == nil then
            return default
        end
    end
    return cur
end

M.load()
return M
