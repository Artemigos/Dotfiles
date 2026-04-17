local M = {}

function M.map(mode, lhs, rhs, opts)
    opts = vim.tbl_extend('force', { silent = true }, opts or {})
    vim.keymap.set(mode, lhs, rhs, opts)
end

function M.defcmd(lhs, rhs, opts)
    opts = vim.tbl_extend('force', { force = true }, opts or {})
    vim.api.nvim_create_user_command(lhs, rhs, opts)
end

function M.try_exec(cmd)
    local output = vim.fn.system(cmd)
    return {
        code = vim.v.shell_error,
        output = output,
    }
end

function M.exec(cmd)
    local result = M.try_exec(cmd)
    if result.code == 0 then
        return result.output
    end
    error('Command "' .. cmd .. '" exited with code ' .. result.code)
end

function M.cached(timeout, reeval, ...)
    local last_eval_ts = 0
    local value = nil
    local varg = { ... }

    return function()
        local now = vim.uv.now()
        if now - last_eval_ts > timeout then
            last_eval_ts = now
            value = reeval(unpack(varg))
        end
        return value
    end
end

return M
