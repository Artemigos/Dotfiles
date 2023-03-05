local M = {}

function M.makefile(opts)
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    opts = opts or {}
    local targets = vim.fn.system(
        [[sh -c "make -pRrq : 2>/dev/null |
            awk -F: '/^# Files/,/^# Finished Make data base/ {
                if (\$1 == \"# Not a target\") skip = 1;
                if (\$1 !~ \"^[#.\t]\") { if (!skip) print \$1; skip=0 }
            }' 2>/dev/null"]])
    local entries = vim.split(targets, '\n')
    entries = vim.tbl_filter(function(x) return x ~= '' end, entries)

    pickers.new(opts, {
        prompt_title = "make targets",
        finder = finders.new_table {
            results = entries,
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                vim.api.nvim_command('!make '..selection[1])
            end)
            return true
        end,
    }):find()
end

return M
