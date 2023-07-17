local M = {}

M.tool_windows = {
    fugitive = 'Git',
    fugitiveblame = 'Git blame',
    NvimTree = 'File tree',
    OverseerList = 'Tasks',
}

local fts = vim.tbl_keys(M.tool_windows)

function M.is_tool_ft(ft)
    return vim.tbl_contains(fts, ft)
end

function M.get_filetypes()
    return fts
end

function M.get_title(ft)
    return M.tool_windows[ft]
end

return M
