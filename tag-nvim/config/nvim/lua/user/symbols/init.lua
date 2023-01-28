local M = {}

function M.choose()
    local symbols = vim.tbl_extend(
        'error',
        require('user.symbols.nerd-font'),
        require('user.symbols.unicode'))
    local names = vim.tbl_keys(symbols)

    local function format(name)
        return symbols[name] .. ' ' .. name
    end

    local function selected(name)
        if name ~= '' then
            vim.api.nvim_put({ symbols[name] }, 'c', true, true)
        end
    end

    vim.ui.select(names, { prompt = 'Select symbol:', format_item = format }, selected)
end

return M
