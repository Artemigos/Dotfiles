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
        },
    },

    { 'tridactyl/vim-tridactyl' },
    { 'gpanders/editorconfig.nvim' },

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
            { '<leader>x<space>', '<cmd>OverseerToggle<CR>' },
            { '<leader>xx', '<cmd>OverseerRun<CR>' },
            { '<leader>xf', '<cmd>OverseerQuickAction open float<CR>' },
        },
    },

    -- perf
    { 'tweekmonster/startuptime.vim' },
    { 'nathom/filetype.nvim' },
}
