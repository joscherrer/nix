local nvim_tree_api = require('nvim-tree.api')

local M = {}

function ToggleTheme()
    if vim.o.background == "dark" then
        vim.cmd("colorscheme onelight")
    else
        vim.cmd("colorscheme onedark")
    end
end

vim.api.nvim_create_user_command('ToggleTheme', ToggleTheme, {})

M.MaxTabs = {}

function Maximize()
    if vim.print(vim.api.nvim_get_option_value("buftype", { buf = 0 })) == "terminal" then
        return
    end

    local tabCount = #vim.api.nvim_list_tabpages()
    local wins = vim.api.nvim_tabpage_list_wins(0)
    local is_floating = function(win_id)
        return vim.api.nvim_win_get_config(win_id).zindex ~= nil
    end

    local winCount = 0
    for _, win in ipairs(wins) do
        if not is_floating(win) then
            winCount = winCount + 1
        end
    end

    if tabCount == 1 and winCount == 1 then
        vim.notify("Only one window and one tab, nothing to un/maximize", vim.log.levels.DEBUG)
        return
    end

    if tabCount > 1 and winCount == 1 then
        vim.notify("Unmaximizing...", vim.log.levels.INFO, { title = "Maximize" })
        vim.cmd("tabclose")
        return
    end

    if tabCount == 1 and winCount > 1 then
        vim.notify("Maximizing...", vim.log.levels.INFO, { title = "Maximize" })
        local buf = vim.api.nvim_get_current_buf()
        local cursor = vim.api.nvim_win_get_cursor(0)
        vim.cmd("tabnew")
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(win, buf)
        vim.api.nvim_win_set_cursor(win, cursor)
    end
end

vim.api.nvim_create_user_command('Maximize', Maximize, {})


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

    if filetype == 'hcl' then
        vim.cmd('silent !hclfmt -w %')
        return
    end

    if filetype == 'javascript' then
        vim.cmd('silent !prettier % --write')
        return
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

function M.close_terminals()
    local terminals = require('toggleterm.terminal').get_all()
    if require('toggleterm.ui').find_open_windows() then
        for _, term in pairs(terminals) do
            term:close()
        end
    end
end

function M.close_all_buffers()
    local bufs = vim.api.nvim_list_bufs()
    for _, i in ipairs(bufs) do
        vim.api.nvim_buf_delete(i, {})
    end
end

local fs = require('luvit.fs')
function M.load_maxtabs()
    local path = vim.fn.stdpath('data') .. '/maxtabs.json'
    fs.readFile(path, function(err, data)
        if err then
            M.MaxTabs = {}
            return
        end
        M.MaxTabs = vim.json.decode(data)
    end)
end

function M.save_maxtabs()
    local path = vim.fn.stdpath('data') .. '/maxtabs.json'
    fs.writeFile(path, vim.json.encode(M.MaxTabs), function(err)
        if err then
            print('Error saving maxtabs')
        end
    end)
end

M.load_maxtabs()

local function findNonTermWindow()
    local wins = vim.api.nvim_tabpage_list_wins(0)
    for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        local bufType = vim.api.nvim_get_option_value("buftype", { buf = buf })
        if bufType == "" then
            return win
        end
    end
    return nil
end

function M.exit_term_focus()
    local bufType = vim.api.nvim_get_option_value("buftype", { buf = 0 })
    if bufType ~= "terminal" then
        return
    end

    local win = findNonTermWindow()
    if win == nil then
        vim.cmd("new")
    else
        vim.api.nvim_set_current_win(win)
    end
end

function M.toggle_nvimtree()
    M.exit_term_focus()
    nvim_tree_api.tree.toggle()
end

function M.toggle_smart_open()
    M.exit_term_focus()
    require("telescope").extensions.smart_open.smart_open({ preview_title = false })
end

function M.random_string(length)
    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local n = string.len(alphabet)
    local pw = {}
    for i = 1, length
    do
        pw[i] = string.byte(alphabet, math.random(n))
    end
    return string.char(unpack(pw))
end

return M
