local M = {}

local env = vim.uv.os_environ()
local config_home = env['XDG_CONFIG_HOME'] or (env['HOME'] .. '/.config/d')
local cache_home = env['XDG_CACHE_HOME'] or (env['HOME'] .. '/.cache/d')
local config_path = config_home .. '/config.toml'
local cache_config_path = cache_home .. '/lua/config.lua'
local cache_lua_dir = cache_home .. '/lua'

function M.load()
    local config_stat = vim.uv.fs_stat(config_path)
    if config_stat == nil then
        vim.notify('Config file not found', vim.log.levels.WARN)
        return
    end

    local luafied_config_stat = vim.uv.fs_stat(cache_config_path)
    if luafied_config_stat == nil or config_stat.mtime.nsec > luafied_config_stat.mtime.nsec then
        local cache_home_stat = vim.uv.fs_stat(cache_home)
        if cache_home_stat == nil then
            vim.uv.fs_mkdir(cache_home, tonumber('700', 8))
        end

        local cache_lua_dir_stat = vim.uv.fs_stat(cache_lua_dir)
        if cache_lua_dir_stat == nil then
            vim.uv.fs_mkdir(cache_lua_dir, tonumber('700', 8))
        end

        require('user.utils').exec('yq -ol ' .. config_path .. ' > ' .. cache_config_path)
        package.loaded['config'] = nil -- invalidate the loaded module to force reloading
    end
    require('config')
end

function M.get(path, default)
    local cur = require('config')
    return vim.tbl_get(cur, unpack(path)) or default
end

function M.get_toggle(toggle_name, default)
    return M.get({ 'toggles', toggle_name }, default == true)
end

vim.opt.rtp:prepend(cache_home)
M.load()
return M
