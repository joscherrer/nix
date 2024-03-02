function ToggleTheme()
    if vim.o.background == "dark" then
        vim.cmd("colorscheme onelight")
    else
        vim.cmd("colorscheme onedark")
    end
end

vim.api.nvim_create_user_command('ToggleTheme', ToggleTheme, {})

local M = {}

function M.buf_get_var(buf, var)
    local success, data = pcall(vim.api.nvim_buf_get_var, buf, var)
    if success and data then
        return data
    end
    return nil
end

function M.buf_get_var_float(buf, var)
    local data = M.buf_get_var(buf, var)
    if data == nil then
        return nil
    end
    return data[vim.val_idx]
end

return M
