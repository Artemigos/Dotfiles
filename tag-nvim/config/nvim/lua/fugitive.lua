local u = require('utils')
local nmap = u.nmap

u.which_key_leader({ g = { name = '+git' } })

local function setup_tracking_cmd()
    local branch = u.exec_cmd('git branch --show-current')
    if branch == nil then
        vim.notify('Not in git repo?', vim.log.levels.ERROR)
        return
    end
    branch = branch:gsub('^%s*', ''):gsub('%s*$', '')
    vim.api.nvim_input(':Git branch --set-upstream-to origin/' .. branch)
end

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
        vim.cmd('Git branch --set-upstream-to origin/' .. branch)
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

nmap('<Leader>gg', ':Git<CR>')
nmap('<Leader>gi', ':Git commit<CR>')
nmap('<Leader>gc', ':Telescope git_commits<CR>')
nmap('<Leader>gp', ':Git push<CR>')
nmap('<Leader>gl', ':Git pull<CR>')
nmap('<Leader>gb', ':Telescope git_branches<CR>')
nmap('<Leader>gs', ':Telescope git_stash<CR>')
nmap('<Leader>gf', ':Git fetch -p<CR>')

vim.keymap.set('n', '<Leader>gt', setup_tracking_cmd)
vim.keymap.set('n', '<Leader>gn', create_new_branch)
vim.keymap.set('n', '<Leader>gP', publish_branch)
