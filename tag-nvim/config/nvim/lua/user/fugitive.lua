local u = require('user.utils')

u.which_key_leader({ g = { name = '+git' } })

local function create_new_branch()
    vim.ui.input('New branch name:', function(branch)
        if branch == nil then
            return
        end

        branch = branch:gsub('^%s*', ''):gsub('%s*$', '')
        if branch:match('%s') then
            vim.notify("Branch name can't contain spaces.", vim.log.levels.ERROR)
            return
        end

        vim.cmd('Git checkout -b ' .. branch)
    end)
end

local function publish_branch()
    local branch = u.exec('git branch --show-current')
    if branch == nil then
        vim.notify('Not in git repo?', vim.log.levels.ERROR)
        return
    end
    branch = branch:gsub('^%s*', ''):gsub('%s*$', '')

    vim.cmd('Git push -u origin ' .. branch)
end

local function toggle_fugitive()
    local fugitive_buf_no = vim.fn.bufnr('^fugitive:')
    local buf_win_id = vim.fn.bufwinid(fugitive_buf_no)
    if fugitive_buf_no >= 0 and buf_win_id >= 0 then
        vim.api.nvim_win_close(buf_win_id, false)
    else
        vim.cmd("Git")
    end
end

u.map('n', '<Leader>gi', ':Git commit<CR>')
u.map('n', '<Leader>gc', ':Telescope git_commits<CR>')
u.map('n', '<Leader>gp', ':Git push<CR>')
u.map('n', '<Leader>gl', ':Git pull<CR>')
u.map('n', '<Leader>gb', ':Telescope git_branches<CR>')
u.map('n', '<Leader>gs', ':Telescope git_stash<CR>')
u.map('n', '<Leader>gf', ':Git fetch -p<CR>')

u.map('n', '<Leader>gg', toggle_fugitive, { desc = 'Toggle git window' })
u.map('n', '<Leader>gn', create_new_branch, { desc = 'New branch' })
u.map('n', '<Leader>gP', publish_branch, { desc = 'Publish (push+set upstream)' })
