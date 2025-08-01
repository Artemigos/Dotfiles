local u = require('user.utils')

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

local function find_repo_web_url()
    local remote = vim.trim(u.exec('git remote get-url origin'))
    if remote == nil then
        return nil
    end
    local host, path
    if vim.startswith(remote, 'https://') then
        local trimmed = remote:sub(9):gsub('%.git$', '')
        local slash_start = trimmed:find('/')
        assert(slash_start)
        host = trimmed:sub(1, slash_start - 1)
        path = trimmed:sub(slash_start + 0)
    else
        local at_start = remote:find('@')
        local colon_start = remote:find(':')
        assert(at_start)
        assert(colon_start)
        host = remote:sub(at_start + 1, colon_start - 1)
        path = '/' .. remote:sub(colon_start + 1):gsub('%.git$', '')
    end

    local config = require('user.localconf').get({ 'git-remotes-host-mapping', host }, {})
    if config.host_override ~= nil then
        host = config.host_override
    end
    if config.path_prefix ~= nil then
        path = config.path_prefix .. path
    end

    return 'https://' .. host .. path
end

local function navigate_to_repo()
    local url = find_repo_web_url()
    if url == nil then
        vim.notify('Cannot get the URL of remote "origin".', vim.log.levels.ERROR)
        return
    end
    local function navigate(input_url)
        if input_url then
            vim.fn.jobstart('xdg-open ' .. input_url)
        end
    end
    vim.ui.input({ prompt = 'URL', default = url }, navigate)
end

return {
    {
        'tpope/vim-fugitive',
        cmd = 'Git',
        keys = {
            { '<Leader>gi', ':Git commit<CR>',                    desc = 'Git commit' },
            { '<Leader>gc', ':Telescope git_commits<CR>',         desc = 'Find commit' },
            { '<Leader>gp', ':Git push<CR>',                      desc = 'Git push' },
            { '<Leader>gl', ':Git pull<CR>',                      desc = 'Git pull' },
            { '<Leader>gL', ':Git pull --rebase --autostash<CR>', desc = 'Git pull --rebase --autostash' },
            { '<Leader>gb', ':Telescope git_branches<CR>',        desc = 'Find branch' },
            { '<Leader>gs', ':Telescope git_stash<CR>',           desc = 'Find stash' },
            { '<Leader>gf', ':Git fetch -p<CR>',                  desc = 'Git fetch -p' },
            { '<Leader>gg', toggle_fugitive,                      desc = 'Toggle git window' },
            { '<Leader>gn', create_new_branch,                    desc = 'New branch' },
            { '<Leader>gP', publish_branch,                       desc = 'Publish (push+set upstream)' },
            { '<Leader>gd', ':Git prune-local<CR>',               desc = 'Git prune-local' },
            { '<Leader>gD', ':Git prune-local -D<CR>',            desc = 'Git prune-local -D' },
            { '<Leader>gm', ':Git blame<CR>',                     desc = 'Git blame' },
            { '<Leader>g@', navigate_to_repo,                     desc = 'Navigate to the repository URL' },
        },
    },
}
