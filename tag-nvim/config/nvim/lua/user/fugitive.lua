local u = require('user.utils')
local nmap = u.nmap

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
    local branch = u.exec_cmd('git branch --show-current')
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

nmap('<Leader>gi', ':Git commit<CR>')
nmap('<Leader>gc', ':Telescope git_commits<CR>')
nmap('<Leader>gp', ':Git push<CR>')
nmap('<Leader>gl', ':Git pull<CR>')
nmap('<Leader>gb', ':Telescope git_branches<CR>')
nmap('<Leader>gs', ':Telescope git_stash<CR>')
nmap('<Leader>gf', ':Git fetch -p<CR>')

vim.keymap.set('n', '<Leader>gg', toggle_fugitive, {desc = 'Toggle git window'})
vim.keymap.set('n', '<Leader>gn', create_new_branch, {desc = 'New branch'})
vim.keymap.set('n', '<Leader>gP', publish_branch, {desc = 'Publish (push+set upstream)'})

vim.api.nvim_create_autocmd('WinLeave', {
    pattern = '*',
    callback = function()
        if vim.o.filetype == 'fugitive' then
            vim.api.nvim_win_close(0, false)
        end
    end,
})
