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
    local branch = require('user.utils').exec('git branch --show-current')
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

local function navigate_to_repo()
    local u = require('user.utils')
    local remote = u.exec('git remote get-url origin')
    if remote == nil then
        vim.notify('Cannot get the URL of remote "origin".', vim.log.levels.ERROR)
        return
    end
    local url = remote:gsub('%s*$', ''):gsub('%.git$', ''):gsub(':', '/'):gsub('^git@', 'https://')
    local function navigate(input_url)
        vim.fn.jobstart('xdg-open ' .. input_url)
    end
    vim.ui.input({ prompt = 'URL', default = url }, navigate)
end

return {
    {
        'tpope/vim-fugitive',
        cmd = 'Git',
        keys = {
            { '<Leader>gi', ':Git commit<CR>',             desc = 'Git commit' },
            { '<Leader>gc', ':Telescope git_commits<CR>',  desc = 'Find commit' },
            { '<Leader>gp', ':Git push<CR>',               desc = 'Git push' },
            { '<Leader>gl', ':Git pull<CR>',               desc = 'Git pull' },
            { '<Leader>gb', ':Telescope git_branches<CR>', desc = 'Find branch' },
            { '<Leader>gs', ':Telescope git_stash<CR>',    desc = 'Find stash' },
            { '<Leader>gf', ':Git fetch -p<CR>',           desc = 'Git fetch -p' },
            { '<Leader>gg', toggle_fugitive,               desc = 'Toggle git window' },
            { '<Leader>gn', create_new_branch,             desc = 'New branch' },
            { '<Leader>gP', publish_branch,                desc = 'Publish (push+set upstream)' },
            { '<Leader>gd', ':Git prune-local<CR>',        desc = 'Git prune-local' },
            { '<Leader>gD', ':Git prune-local -D<CR>',     desc = 'Git prune-local -D' },
            { '<Leader>gm', ':Git blame<CR>',              desc = 'Git blame' },
            { '<Leader>g@', navigate_to_repo,              desc = 'Navigate to the repository URL' },
        },
    },

    {
        'tridactyl/vim-tridactyl',
        ft = 'tridactyl',
        init = function()
            vim.api.nvim_create_autocmd('FileType', {
                group = vim.api.nvim_create_augroup('tridactyl', { clear = true }),
                pattern = 'tridactyl',
                callback = function()
                    vim.wo.foldmethod = 'marker'
                    vim.wo.foldmarker = '"{,}"'
                end,
            })
        end,
    },

    {
        'stevearc/overseer.nvim',
        opts = {
            task_editor = {
                bindings = {
                    n = {
                        ['<Esc>'] = 'Cancel',
                    },
                },
            },
        },
        keys = {
            { '<leader>x<space>', '<cmd>OverseerToggle<CR>',                 desc = 'Show tasks' },
            { '<leader>xx',       '<cmd>OverseerRun<CR>',                    desc = 'Run task' },
            { '<leader>xf',       '<cmd>OverseerQuickAction open float<CR>', desc = 'Show last task' },
        },
    },

    -- perf
    { 'tweekmonster/startuptime.vim' },
}
