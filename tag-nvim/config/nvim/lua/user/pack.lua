local M = {
    post_add_build_steps = {},
    post_load_build_steps = {},
}

function M.setup()
    local group = vim.api.nvim_create_augroup('user.pack', { clear = true })
    vim.api.nvim_create_autocmd('PackChanged', {
        group = group,
        callback = function(ev)
            local kind = ev.data.kind
            if kind == 'install' or kind == 'update' then
                local name = ev.data.spec.name

                local immediate_steps = M.post_add_build_steps[name]
                if immediate_steps ~= nil and #immediate_steps > 0 then
                    for _, cb in ipairs(immediate_steps) do
                        cb(ev)
                    end
                end

                local deferred_steps = M.post_load_build_steps[name]
                if deferred_steps ~= nil and #deferred_steps > 0 then
                    if vim.v.vim_did_init == 1 then
                        for _, cb in ipairs(deferred_steps) do
                            cb(ev)
                        end
                    else
                        vim.api.nvim_create_autocmd('VimEnter', {
                            group = group,
                            callback = function()
                                for _, cb in ipairs(deferred_steps) do
                                    cb(ev)
                                end
                                return true
                            end,
                        })
                    end
                end
            end
        end,
    })
end

function M.get_pack_name(spec)
    local name = spec.name or spec.src:gsub('%.git$', '')
    name = (type(name) == 'string' and name or ''):match('[^/]+$') or ''
    return name
end

function M.register_post_add_build_step(pack_name, callback)
    if M.post_add_build_steps[pack_name] == nil then
        M.post_add_build_steps[pack_name] = {}
    end
    vim.list_extend(M.post_add_build_steps[pack_name], { callback })
end

function M.register_post_load_build_step(pack_name, callback)
    if M.post_load_build_steps[pack_name] == nil then
        M.post_load_build_steps[pack_name] = {}
    end
    vim.list_extend(M.post_load_build_steps[pack_name], { callback })
end

function M.with_post_add_build_step(spec, callback)
    local pack_name = M.get_pack_name(spec)
    M.register_post_add_build_step(pack_name, callback)
    return spec
end

function M.with_post_load_build_step(spec, callback)
    local pack_name = M.get_pack_name(spec)
    M.register_post_load_build_step(pack_name, callback)
    return spec
end

function M.system_step(cmd)
    local function f(ev)
        vim.system(cmd, { cwd = ev.data.path }):wait()
    end
    return f
end

function M.vim_cmd_step(cmd)
    local function f()
        vim.cmd(cmd)
    end
    return f
end

return M
