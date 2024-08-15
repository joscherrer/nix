local M = {}

local has_telescope, _ = pcall(require, "telescope")
if not has_telescope then
    error("The command palette requires telescope.nvim")
end

vim.api.nvim_set_hl(0, "palette.category.palette", { fg = "#6492e3" })
vim.api.nvim_set_hl(0, "palette.category.git", { fg = "#64e364" })
vim.api.nvim_set_hl(0, "palette.category.default", {})
vim.api.nvim_set_hl(0, "PaletteItemDescription", {})
vim.api.nvim_set_hl(0, "PaletteMapMode", { bg = "#00ff00", fg = "#000000" })
vim.api.nvim_set_hl(0, "PaletteMapInsert", { fg = '#ffffff', bg = '#2F3F59' })
vim.api.nvim_set_hl(0, "PaletteMapVisual", { fg = '#ffffff', bg = '#412F26' })
vim.api.nvim_set_hl(0, "PaletteMapNormal", { fg = '#2d303d', bg = '#ffffff' })
vim.api.nvim_set_hl(0, "PaletteMapTerminal", { fg = '#ffffff', bg = '#56303B' })

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local entry_display = require("telescope.pickers.entry_display")

local separator = " │ "

local commands = {}
local command_ids = {}

local kc_map = {
    -- ["C"] = "󰘴",
    -- ["S"] = "󰘶",
    -- ["A"] = "󰘵",
    -- ["M"] = "󰘵",
    -- ["D"] = "󰘳",
    ["C"] = "Ctrl",
    ["S"] = "Shift",
    ["A"] = "Alt",
    ["M"] = "Alt",
    ["D"] = "Super",
    ["leader"] = "󱁐"
}

local mode_icons = {
    n = " N ",
    i = " I ",
    v = " V ",
    t = " T "
}

local mode_highlights = {
    n = "PaletteMapNormal",
    i = "PaletteMapInsert",
    v = "PaletteMapVisual",
    t = "PaletteMapTerminal",
}

local category_highlights = {
    ["Palette"] = "palette.category.palette",
    ["Colorizer"] = "palette.category.colorizer",
    ["Trouble"] = "palette.category.trouble",
    ["Git"] = "palette.category.git",
    ["Picker"] = "palette.category.picker",
    ["Overseer"] = "palette.category.overseer",
    ["View"] = "palette.category.view",
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

local function picker_action(prompt_bufnr, _)
    actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()

        if type(selection.value.cmd.cmd) == "function" then
            selection.value.cmd.cmd()
        else
            vim.cmd(selection.value.cmd.cmd or selection.value.cmd.name)
        end
    end)
    return true
end


M.picker = function(opts)
    opts          = opts or {}
    local results = M.list()
    local columns = {
        category = { width = 0 },
        desc = { width = 30 },
    }

    for _, entry in ipairs(results) do
        columns.category.width = math.min(math.max(columns.category.width, #entry.category + 1), 15)
        columns.desc.width = math.min(math.max(columns.desc.width, #entry.desc + 1), 30)
        for mode, key in pairs(entry.keys_display) do
            local mopts = columns[mode] or {}
            columns[mode] = { width = math.min(math.max(mopts.width or 0, key.width), 20) }
        end
    end

    local modes = {}
    for key, _ in pairs(columns) do
        if key ~= "desc" and key ~= "category" then
            table.insert(modes, key)
        end
    end

    table.sort(modes)

    local items = {
        columns.category,
        columns.desc
    }
    for _, mode in ipairs(modes) do
        table.insert(items, columns[mode])
    end

    local displayer    = entry_display.create({ separator = separator, items = items })
    local make_display = function(entry)
        local display_columns = {
            { entry.value.category, category_highlights[entry.value.category] or "palette.category.default" },
            { entry.value.desc,     "PaletteItemDescription" },
        }

        local mode_hl = {}
        local col_index = columns.category.width + #separator + columns.desc.width + #separator
        if #entry.value.desc > 40 then
            col_index = col_index + string.len("…") - 1
        end
        if #entry.value.category > 20 then
            col_index = col_index + string.len("…") - 1
        end

        for _, mode in ipairs(modes) do
            local lhs = entry.value.keys_display[mode]
            local offset = 0
            if lhs then
                table.insert(mode_hl, { { col_index, col_index + lhs.icon_size }, lhs.hl_name })
                table.insert(display_columns, { lhs.repr })
                offset = lhs.width_offset
            else
                table.insert(display_columns, { " " })
            end
            col_index = columns[mode].width + #separator + col_index + offset
        end

        local final_str, highlights = displayer(display_columns)
        vim.list_extend(highlights, mode_hl)

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
                    ordinal = entry.desc
                }
            end
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = picker_action
    }):find()
end



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

--- @class bbrain.palette.item.Opts
--- @field cmd bbrain.palette.cmd
--- @field keys bbrain.keymap.key[]
--- @field desc string
--- @field category string?

--- Add an item to the command palette.
---
--- @param category string
--- @param name string
--- @param opts bbrain.palette.item.Opts
function M.add(category, name, opts)
    local id = category .. "::" .. name
    if command_ids[id] then
        return
    end

    if not category then
        category = "Misc"
    end

    if opts.cmd.create then
        vim.api.nvim_create_user_command(opts.cmd.name, opts.cmd.cmd, opts.cmd.opts)
    end

    local keys_display = {}

    for _, key in ipairs(opts.keys) do
        local rhs = opts.cmd.cmd or ("<Cmd>" .. opts.cmd.name .. "<CR>")
        vim.keymap.set(key.mode, key.lhs, rhs, key.opts)

        local mods, kc, parts = parse_lhs(key.lhs)
        local keybind = ""
        for _, mod in ipairs(mods) do
            keybind = keybind .. mod .. "+"
        end
        keybind = keybind .. kc .. " "
        if #parts ~= 0 then
            keybind = keybind .. table.concat(parts, "")
        end

        if type(key.mode) == "string" then
            ---@diagnostic disable-next-line: assign-type-mismatch
            key.mode = { key.mode }
        end

        ---@diagnostic disable-next-line: param-type-mismatch
        for _, mode in ipairs(key.mode) do
            local mode_icon = mode_icons[mode] or ("[" .. string.upper(mode) .. "]")
            local key_repr = mode_icon .. " " .. keybind
            keys_display[mode] = {
                repr = key_repr,
                icon_size = #mode_icon,
                hl_name = mode_highlights[mode] or "PaletteMapNormal",
                width = #key_repr,
                width_offset = #key_repr - vim.fn.strdisplaywidth(key_repr)
            }
        end
    end

    command_ids[id] = true
    table.insert(commands, {
        cmd = opts.cmd,
        keys = opts.keys,
        desc = opts.desc,
        category = category,
        keys_display = keys_display
    })
end

function M.list()
    table.sort(commands, function(a, b) return a.category > b.category end)
    return commands
end

function M.reload()
    commands = {}
    command_ids = {}
    package.loaded["bbrain.palette"] = nil
end

M.add("Palette", "PaletteOpen", {
    cmd = { name = "PaletteOpen", cmd = function() require('bbrain.palette').picker() end },
    keys = { { mode = { "n", "t", "v", "i" }, lhs = "<C-S-p>", opts = {} } },
    desc = "Open command palette",
})
M.add("Palette", "PaletteReload", {
    cmd = { name = "PaletteReload", cmd = function() require('bbrain.palette').reload() end },
    keys = { { mode = "n", lhs = "<leader>rp", opts = {} } },
    desc = "Reload command palette",
})
M.add("Colorizer", "ColorizerToggle", {
    cmd = { name = "ColorizerToggle" },
    keys = { { mode = { "n" }, lhs = "<leader>tc", opts = {} } },
    desc = "Toggle hex colors highlight",
})
M.add("Trouble", "TroubleDiagnostics", {
    cmd = { name = "Trouble diagnostics" },
    keys = {},
    desc = "Open Diagnostics",
})
-- M.add({ name = "Telescope find_files" })
M.add("Git", "GitBranches", {
    cmd = { name = "Telescope git_branches" },
    keys = {},
    desc = "Checkout branch",
})
M.add("Picker", "PickerHighlights", {
    cmd = { name = "Telescope highlights" },
    keys = {},
    desc = "Show highlights"
})

M.add("Overseer", "OverseerOpen", {
    cmd = { name = "OverseerToggle" },
    keys = {},
    desc = "Toggle UI"
})
M.add("Overseer", "OverseerRun", {
    cmd = { name = "OverseerRun" },
    keys = {},
    desc = "Run Task"
})
M.add("View", "MaximizePane", {
    cmd = { name = "Maximize pane", cmd = vim.cmd.Maximize },
    keys = { { mode = { "n" }, lhs = "<leader>mm", opts = {} } },
    desc = "Toggle maximize"
})
M.add("Picker", "PickerRegisters", {
    cmd = { name = "Telescope registers" },
    keys = { { mode = { "n", "c", "v", "i" }, lhs = "<F8>", opts = {} } },
    desc = "Show registers"
})

return M
