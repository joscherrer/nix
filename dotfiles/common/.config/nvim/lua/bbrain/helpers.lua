function ToggleTheme()
    if vim.o.background == "dark" then
        vim.cmd("colorscheme onelight")
    else
        vim.cmd("colorscheme onedark")
    end
end

vim.api.nvim_create_user_command('ToggleTheme', ToggleTheme, {})

MaxTabs = {}

function Maximize()
    local win = vim.api.nvim_get_current_win()
    local cursor = vim.api.nvim_win_get_cursor(0)
    if MaxTabs[win] then
        vim.cmd("tabclose")
        local main_win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_cursor(main_win, cursor)
        MaxTabs[win] = nil
        return
    end

    local buf = vim.api.nvim_get_current_buf()
    vim.cmd("tabnew")
    win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
    vim.api.nvim_win_set_cursor(win, cursor)
    MaxTabs[win] = true
end

vim.api.nvim_create_user_command('Maximize', Maximize, {})

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
