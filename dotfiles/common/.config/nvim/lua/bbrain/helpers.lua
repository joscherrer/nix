local nvim_tree_api = require('nvim-tree.api')
local fs = require('luvit.fs')

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

function M.toggle_maximize()
    Maximize()
end

function M.is_maximized()
    local ok, max = pcall(vim.api.nvim_tabpage_get_var, 0, "maximized")
    if ok and max then
        return true
    end

    if ok and not max then
        return false
    end

    -- When restoring a session, the maximized variable is not kept
    local tabs = vim.api.nvim_list_tabpages()
    local tab = vim.api.nvim_get_current_tabpage()
    if #tabs > 1 and tabs[#tabs] == tab then
        return true
    end

    return false
end

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

    if M.is_maximized() then
        vim.notify("Unmaximizing...", vim.log.levels.INFO, { title = "Maximize" })
        vim.cmd.tabclose('$')
        return
    end

    -- if not ok and tabCount > 1 then
    --     vim.notify("Unmaximizing...", vim.log.levels.INFO, { title = "Maximize" })
    --     vim.cmd.tabclose('$')
    --     return
    -- end

    if tabCount == 1 and winCount > 1 then
        vim.notify("Maximizing...", vim.log.levels.INFO, { title = "Maximize" })
        local buf = vim.api.nvim_get_current_buf()
        local cursor = vim.api.nvim_win_get_cursor(0)
        vim.cmd.tabnew()
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_tabpage_set_var(0, "maximized", true)
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
    local params = vim.lsp.util.make_range_params(0, "utf-16")
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

    if filetype == 'alloy' then
        vim.cmd('silent !alloy fmt %')
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
    require('snacks').bufdelete.all()
    -- local bufs = vim.api.nvim_list_bufs()
    -- for _, i in ipairs(bufs) do
    --     vim.api.nvim_buf_delete(i, {})
    -- end
end

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

function M.get_term_by_winid(winid)
    for _, term in ipairs(require('toggleterm.terminal').get_all()) do
        if term.window == winid then
            return term
        end
    end
end

function M.swap_term_buf(id, curr_winid)
    local next_term = require('toggleterm.terminal').get_or_create_term(id)
    local curr_term = M.get_term_by_winid(curr_winid)

    if not curr_term then return end

    if curr_term.window == next_term.window then return end
    curr_term:persist_mode()

    curr_term.window, next_term.window = next_term.window, curr_term.window
    vim.api.nvim_win_set_buf(next_term.window, next_term.bufnr)
end

local function create_term_buf_if_needed(term)
    local valid_win = term.window and vim.api.nvim_win_is_valid(term.window)
    local window = valid_win and term.window or vim.api.nvim_get_current_win()
    -- If the buffer doesn't exist create a new one
    local valid_buf = term.bufnr and vim.api.nvim_buf_is_valid(term.bufnr)
    local bufnr = valid_buf and term.bufnr or vim.api.nvim_create_buf(false, false)
    -- Assign buf to window to ensure window options are set correctly
    vim.api.nvim_win_set_buf(window, bufnr)
    term.window, term.bufnr = window, bufnr
    term:__set_options()
    vim.api.nvim_set_current_buf(bufnr)
end


function M.winbar_new_click()
    M.new_term()
end

function M.winbar_click(id)
    if not id then return end
    local winid = vim.fn.getmousepos().winid
    M.swap_term_buf(id, winid)
end

local function get_open_term()
    local terms = require('toggleterm.terminal')
    local candidates = {
        (terms.get_last_focused() or {}).window,
        vim.fn.getmousepos().winid,
        vim.api.nvim_get_current_win(),
    }

    local selected = terms.find(function(t)
        if vim.tbl_contains(candidates, t.window) then
            return true
        end
    end)

    if not selected then
        selected = terms.find(function(t)
            return t:is_open()
        end)
    end

    return selected
end

function M.open_term(id)
    local terms = require('toggleterm.terminal')
    local selected = get_open_term()

    if not selected then
        vim.notify("No terminal window found", vim.log.levels.WARN, { title = "ToggleTerm" })
        return
    end

    M.swap_term_buf(id, selected.window)
    terms.get(id):focus()
end

function M.new_term()
    local curr_term = get_open_term()
    if not curr_term then
        vim.notify("No terminal window found", vim.log.levels.WARN, { title = "ToggleTerm" })
        return
    end

    local terms = require('toggleterm.terminal')
    local ui = require('toggleterm.ui')
    local next_term = terms.get_or_create_term(terms.next_id())
    ui.update_origin_window(next_term.window)
    curr_term:persist_mode()

    curr_term.window, next_term.window = next_term.window, curr_term.window
    create_term_buf_if_needed(next_term)

    next_term:spawn()
    ui.hl_term(next_term)
    if next_term.on_open then
        next_term:on_open()
    end
end

function M.next_term(reverse)
    local terms = require('toggleterm.terminal')
    local curr = get_open_term()

    if not curr then
        vim.notify("No terminal window found", vim.log.levels.WARN, { title = "ToggleTerm" })
        return
    end

    local all = terms.get_all()
    local candidate

    for i, term in ipairs(all) do
        if term.id == curr.id then
            if reverse and i == 1 then
                candidate = all[#all]
            elseif reverse then
                candidate = all[i - 1]
            elseif i == #all then
                candidate = all[1]
            else
                candidate = all[i + 1]
            end
        end
    end

    if not candidate then
        vim.notify("No terminal found", vim.log.levels.WARN, { title = "ToggleTerm" })
        return
    end

    M.swap_term_buf(candidate.id, curr.window)

    return candidate
end

function M.close_term()
    local terms = require('toggleterm.terminal')

    local term = terms.find(function(t)
        return t.window == vim.fn.getmousepos().winid
    end) or get_open_term()

    vim.notify("Closing terminal " .. term.id, vim.log.levels.DEBUG, { title = "ToggleTerm" })

    if not term then
        vim.notify("No terminal window found", vim.log.levels.WARN, { title = "ToggleTerm" })
        return
    end
    vim.g.bbrain_just_closed_terminal = true

    local next_term = M.next_term(true)
    vim.notify("Terminal buf" .. term.bufnr, vim.log.levels.DEBUG, { title = "ToggleTerm" })
    vim.api.nvim_buf_delete(term.bufnr, { force = true })

    if next_term then
        next_term:__restore_mode()
    end
end

function M.pgrep(pattern)
    local handle = io.popen("pgrep -f " .. pattern)
    if not handle then
        vim.notify("Failed to open process handle for '" .. pattern .. "'", vim.log.levels.ERROR)
        return nil
    end

    local pid = handle:read("*l")
    handle:close()

    if pid then
        return tonumber(pid)
    else
        vim.notify("Process '" .. pattern .. "' not found.", vim.log.levels.DEBUG)
        return nil
    end
end

function M.signal_hyprfollow()
    local pid = tonumber(M.pgrep("hyprfollow"))
    if not pid or type(pid) ~= "number" then
        vim.notify("Process 'hyprfollow' not found.", vim.log.levels.DEBUG)
        return
    end

    local sig = "sigusr1"
    local ok, err = vim.uv.kill(pid, sig)
    if ok then
        vim.notify("Sent SIGUSR1 to hyprfollow (PID: " .. pid .. ")", vim.log.levels.DEBUG)
    else
        vim.notify("Failed to send signal: " .. tostring(err), vim.log.levels.ERROR)
    end
end

function M.get_ppid()
    local handle = io.popen("ps -o ppid= -p " .. tostring(vim.fn.getpid()))
    if not handle then
        vim.notify("Failed to open process handle for PID: " .. tostring(vim.fn.getpid()), vim.log.levels.ERROR)
        return nil
    end

    local ppid = handle:read("*l")
    handle:close()

    if ppid then
        return tonumber(ppid)
    else
        print("Parent process not found.")
        return nil
    end
end

return M
