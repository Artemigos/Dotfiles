which_key_leader({
    d = {
        name = '+dotnet',
        T = 'Test selected project',
        B = 'Build selected project',
        R = 'Run selected project',
    }
})

function _G.telescope_select_and_run(filter, command)
    local actions = require('telescope.actions')
    local state = require('telescope.actions.state')
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values

    local opts = { find_command = { 'find', '.', '-name', filter } }
    local function _confirm(prompt_bufnr)
        local selection = state.get_selected_entry()
        if selection == nil then
            return
        end
        actions.close(prompt_bufnr)
        vim.cmd(command..' '..selection[1])
    end

    pickers.new(opts, {
        prompt_title = 'Select Project',
        finder = finders.new_oneshot_job(opts.find_command, opts),
        previewer = conf.file_previewer(opts),
        sorter = conf.file_sorter(opts),
        attach_mappings = function(_, map)
            map('i', '<CR>', _confirm)
            map('n', '<CR>', _confirm)
            return true
        end,
    }):find()
end

nmap('<Leader>dt', ':!dotnet test<CR>')
nmap('<Leader>db', ':!dotnet build<CR>')
nmap('<Leader>dr', ':!dotnet run<CR>')
nmap('<Leader>dT', ':lua telescope_select_and_run("*.csproj", "!dotnet test")<CR>')
nmap('<Leader>dB', ':lua telescope_select_and_run("*.csproj", "!dotnet build")<CR>')
nmap('<Leader>dR', ':lua telescope_select_and_run("*.csproj", "!dotnet run --project")<CR>')
