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

return {
    {
        'tpope/vim-fugitive',
        cmd = 'Git',
        keys = {
            { '<Leader>gi', ':Git commit<CR>' },
            { '<Leader>gc', ':Telescope git_commits<CR>' },
            { '<Leader>gp', ':Git push<CR>' },
            { '<Leader>gl', ':Git pull<CR>' },
            { '<Leader>gb', ':Telescope git_branches<CR>' },
            { '<Leader>gs', ':Telescope git_stash<CR>' },
            { '<Leader>gf', ':Git fetch -p<CR>' },
            { '<Leader>gg', toggle_fugitive, desc = 'Toggle git window' },
            { '<Leader>gn', create_new_branch, desc = 'New branch' },
            { '<Leader>gP', publish_branch, desc = 'Publish (push+set upstream)' },
            { '<Leader>gd', ':Git prune-local<CR>' },
            { '<Leader>gD', ':Git prune-local -D<CR>' },
            { '<Leader>gm', ':Git blame<CR>' },
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
            { '<leader>x<space>', '<cmd>OverseerToggle<CR>', desc = 'Show tasks' },
            { '<leader>xx', '<cmd>OverseerRun<CR>', desc = 'Run task' },
            { '<leader>xf', '<cmd>OverseerQuickAction open float<CR>', desc = 'Show last task' },
        },
    },

    -- perf
    { 'tweekmonster/startuptime.vim' },
}
