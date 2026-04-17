local M = {}

function M.makefile(opts)
    opts = opts or {}
    local targets = vim.fn.system(
        [[sh -c "make -pRrq : 2>/dev/null |
            awk -F: '/^# Files/,/^# Finished Make data base/ {
                if (\$1 == \"# Not a target\") skip = 1;
                if (\$1 !~ \"^[#.\t]\") { if (!skip) print \$1; skip=0 }
            }' 2>/dev/null"]])
    local entries = vim.split(targets, '\n')
    entries = vim.tbl_filter(function(x) return x ~= '' end, entries)

    ---@type snacks.picker.Item[]
    local items = {}
    for i, entry in ipairs(entries) do
        table.insert(items, {
            idx = i,
            score = 1,
            text = entry,
            file = 'Makefile',
        })
    end

    Snacks.picker.pick({
        title = 'make targets',
        items = items,
        format = 'text',
        confirm = function(self, item)
            self:close()
            if item == nil then
                return
            end
            vim.api.nvim_command('!make ' .. item.text)
        end,
    })
end

return M
