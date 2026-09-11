local function setup_workspaces()
    local monitors = {
        home = {
            left = "desc:Dell Inc. DELL U2415 7MT0167B2YNL",
            right = "desc:LG Electronics LG HDR WQHD+ 205NTCZ8L675"
        },
        work = {
            left = "desc:Lenovo Group Limited L27qe UTP02GR9",
            right = "desc:Lenovo Group Limited L27qe UTP02GR4"
        }
    }

    local selected_monitors
    if hl.get_monitor(monitors.home.left) then
        selected_monitors = monitors.home
    else
        selected_monitors = monitors.work
    end
    hl.workspace_rule({
        workspace = 1,
        monitor = selected_monitors.right,
        persistent = true,
        is_default = true,
    })
    hl.workspace_rule({
        workspace = 2,
        monitor = selected_monitors.left,
        persistent = true,
        is_default = true,
        layoutopt = "orientation:top",
    })
    hl.workspace_rule({
        workspace = 3,
        monitor = selected_monitors.right,
        persistent = true,
        is_default = false,
    })
    hl.workspace_rule({
        workspace = 4,
        monitor = selected_monitors.left,
        persistent = true,
        is_default = false,
        layoutopt = "orientation:top",
    })
    hl.workspace_rule({
        workspace = 5,
        monitor = selected_monitors.right,
        persistent = true,
        is_default = false,
    })
    hl.workspace_rule({
        workspace = 6,
        monitor = selected_monitors.left,
        persistent = true,
        is_default = false,
        layoutopt = "orientation:top",
    })
    hl.workspace_rule({
        workspace = 7,
        monitor = selected_monitors.right,
        persistent = true,
        is_default = false,
    })
    hl.workspace_rule({
        workspace = 8,
        monitor = selected_monitors.left,
        persistent = true,
        is_default = false,
        layoutopt = "orientation:top",
    })
    hl.workspace_rule({
        workspace = 9,
        monitor = selected_monitors.right,
        persistent = true,
        is_default = false,
    })
    hl.workspace_rule({
        workspace = 10,
        monitor = selected_monitors.left,
        persistent = true,
        is_default = false,
        layoutopt = "orientation:top",
    })
end

setup_workspaces()

hl.on("monitor.added", setup_workspaces)
hl.on("monitor.removed", setup_workspaces)
