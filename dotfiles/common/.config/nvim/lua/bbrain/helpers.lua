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

local function format_go()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
    for cid, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            if r.edit then
                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                vim.lsp.util.apply_workspace_edit(r.edit, enc)
            end
        end
    end
end

function M.format(buffer, opts)
    opts = opts or { async = false }

    local filetype = vim.api.nvim_get_option_value('filetype', { buf = buffer })

    if filetype == 'python' then
        vim.cmd('silent !black %')
        return
    end

    if filetype == 'go' then
        format_go()
    end
    vim.lsp.buf.format(opts)
    vim.cmd('silent! write')
end

M.telescope = { config = {} }

if vim.g.neovide then
    M.telescope.config.borderchars = {
        prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
        results = { " " },
        preview = { " " }
    }
end

return M
