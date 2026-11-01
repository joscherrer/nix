-- Workspaces 1-10 alternate right/left (odd on the right monitor, even on
-- the left one) over the first connected set from host.lua (see
-- base/monitors.lua). 1 and 2 are each monitor's default workspace.
local host = package.searchpath("host", package.path) and require("host") or {}
local sets = host.workspace_sets or {}

local function setup_workspaces()
    local selected
    for _, set in ipairs(sets) do
        if hl.get_monitor(set.left.monitor) then
            selected = set
            break
        end
    end
    if not selected then
        return
    end

    for ws = 1, 10 do
        local side = (ws % 2 == 1) and selected.right or selected.left
        hl.workspace_rule({
            workspace = ws,
            monitor = side.monitor,
            persistent = true,
            default = ws <= 2,
            layout_opts = side.layout_opts or {},
        })
    end
end

setup_workspaces()

hl.on("monitor.added", setup_workspaces)
hl.on("monitor.removed", setup_workspaces)
