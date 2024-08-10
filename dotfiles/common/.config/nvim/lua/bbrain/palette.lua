local M = {}

local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
    error("The command palette requires telescope.nvim")
end

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local entry_display = require("telescope.pickers.entry_display")

local separator = " │ "

local kc_symbols = {
    C = "󰘴",
    S = "󰘶",
    A = "󰘵",
    M = "󰘵",
    D = "󰘳",
}

local kc_map = {
    ["C"] = "Ctrl",
    ["S"] = "Shift",
    ["A"] = "Alt",
    ["M"] = "Alt",
    ["D"] = "Super",
    ["leader"] = "󱁐"
}

local function parse_lhs(lhs)
    local parts = {}
    local in_kc = false
    local kc = ""
    local mods = {}
    for i = 1, #lhs do
        local c = lhs:sub(i, i)

        if c == ">" then
            in_kc = false
            if kc == "leader" then
                kc = kc_map[kc]
            end
        elseif in_kc then
            local prev = lhs:sub(i - 1, i - 1)
            local next = lhs:sub(i + 1, i + 1)
            local is_single = (prev == "<" or prev == "-") and (next == "-")
            if vim.list_contains({ "S", "C", "M", "A", "T", "D" }, c) and is_single then
                table.insert(mods, kc_map[c])
            elseif c == "-" then
                -- ignore
            else
                kc = kc .. c
            end
        elseif c == "<" then
            in_kc = true
        else
            table.insert(parts, c)
        end
    end
    return mods, kc, parts
end

local function picker_action(prompt_bufnr, map)
    actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vim.notify("Running " .. selection.value.desc)
        if type(selection.value.cmd.cmd) == "function" then
            selection.value.cmd.cmd()
        else
            vim.cmd(selection.value.cmd.cmd or selection.value.cmd.name)
        end
    end)
    return true
end


M.picker = function(opts)
    opts = opts or {}
    local displayer = entry_display.create({
        separator = separator,
        items = {
            { width = 20 },
            { width = 20 },
            { width = 20 },
        }
    })
    local make_display = function(entry)
        local final_str, highlights = displayer({
            { entry.value.cmd.name },
            { entry.value.desc },
            { table.concat(entry.value.keys_display, "  ") or "" },
        })
        -- vim.print(final_str)
        -- vim.print(highlights)
        return final_str, highlights
    end
    pickers.new(opts, {
        prompt_title = "Command palette",
        finder = finders.new_table({
            results = M.list(),
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = make_display,
                    ordinal = entry.cmd.name
                }
            end
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = picker_action
    }):find()
end

local commands = {}
local keys_cache = {}


--- @class bbrain.palette.cmd
--- @field name string
--- @field create? boolean
--- @field cmd? string|function
--- @field opts? vim.api.keyset.user_command
---
--- @class bbrain.keymap.key
--- @field mode string|string[]
--- @field lhs string
--- @field opts vim.keymap.set.Opts



--- Add an item to the command palette.
---
--- @param cmd bbrain.palette.cmd
--- @param keys bbrain.keymap.key[]
--- @param desc string
function M.add(cmd, keys, desc)
    if cmd.create then
        vim.api.nvim_create_user_command(cmd.name, cmd.cmd, cmd.opts)
    end

    local keys_display = {}

    for _, key in ipairs(keys) do
        local rhs = cmd.cmd or ("<Cmd>" .. cmd.name .. "<CR>")
        vim.keymap.set(key.mode, key.lhs, rhs, key.opts)

        local mods, kc, parts = parse_lhs(key.lhs)
        local display = ""
        for _, mod in ipairs(mods) do
            display = display .. mod .. "+"
        end
        display = display .. kc .. " "
        if #parts ~= 0 then
            display = display .. table.concat(parts, "")
        end
        table.insert(keys_display, display)
    end
    if next(keys_display) == nil then
        table.insert(keys_display, "Unbound")
    end

    table.insert(commands, { cmd = cmd, keys = keys, desc = desc, keys_display = keys_display })
end

function M.list()
    return commands
end

M.add(
    { name = "Palette", cmd = function() require('bbrain.palette').picker() end },
    { { mode = "n", lhs = "<C-S-p>", opts = {} } },
    "Palette: Open"
)
M.add({ name = "ColorizerToggle" }, { { mode = "n", lhs = "<leader>tc", opts = {} } }, "Colorizer: Toggle")
M.add({ name = "Trouble" }, {}, "Trouble: Toggle")

-- vim.highlight.create("PaletteDescription")
-- vim.highlight.create("PaletteCommand")
-- vim.highlight.create("PaletteKeys")

return M
