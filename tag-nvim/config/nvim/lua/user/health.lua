local health = vim.health

local function check_cmd(cmd)
    vim.cmd('silent !' .. cmd)
    return vim.v.shell_error == 0
end

local function check_exec(cmd)
    return check_cmd('command -v ' .. cmd)
end

local function check_server(server_name, available, advice)
    if available then
        health.ok(string.format('server "%s" available', server_name))
    else
        health.warn(string.format('server "%s" missing', server_name), advice)
    end
end

return {
    check = function()
        health.start('LSP servers')
        check_server('luals', check_exec('lua-language-server'), 'on Arch: pacman -S lua-language-server')
        check_server('bashls', check_exec('bash-language-server'), 'npm i -g bash-language-server')
        check_server('jedi', check_exec('jedi-language-server'), 'pip install -U jedi_language_server')
        check_server('vimls', check_exec('vim-language-server'), 'npm i -g vim-language-server')
        check_server('html/css/json', check_exec('vscode-json-language-server'), 'npm i -g vscode-langservers-extracted')
        check_server('yamlls', check_exec('yaml-language-server'), 'npm i -g yaml-language-server')
        check_server('rust-analyzer', check_exec('rust-analyzer'), 'on Arch: pacman -S rust-analyzer')
        check_server('tsserver', check_exec('typescript-language-server'),
            'npm i -g typescript typescript-language-server')
    end
}
