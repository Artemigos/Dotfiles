local u = require('utils')
local nmap = u.nmap

u.which_key_leader({
    d = {
        name = '+dotnet',
        T = 'Test selected project',
        B = 'Build selected project',
        R = 'Run selected project',
    }
})

nmap('<Leader>dt', ':!dotnet test<CR>')
nmap('<Leader>db', ':!dotnet build<CR>')
nmap('<Leader>dr', ':!dotnet run<CR>')
nmap('<Leader>dT', ':lua require("utils").telescope_select_and_run("*.csproj", "!dotnet test")<CR>')
nmap('<Leader>dB', ':lua require("utils").telescope_select_and_run("*.csproj", "!dotnet build")<CR>')
nmap('<Leader>dR', ':lua require("utils").telescope_select_and_run("*.csproj", "!dotnet run --project")<CR>')
