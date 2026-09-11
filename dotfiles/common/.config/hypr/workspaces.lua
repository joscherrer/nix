local function setup_workspaces()
    local monitors = {
        home = {
            left = {
                monitor = "desc:Dell Inc. DELL U2415 7MT0167B2YNL",
                layout_opts = {
                    orientation = "top"
                }
            },
            right = {
                monitor = "desc:LG Electronics LG HDR WQHD+ 205NTCZ8L675",
                layout_opts = {}
            },
        },
        work = {
            left = {
                monitor = "desc:Lenovo Group Limited L27qe UTP02GR9",
                layout_opts = {
                    orientation = "top"
                }
            },
            right = {
                monitor = "desc:Lenovo Group Limited L27qe UTP02GR4",
                layout_opts = {}
            },
        },
        bare = {
            left = {
                monitor = "eDP-1",
                layout_opts = {}

            },
            right = {
                monitor = "DP-1",
                layout_opts = {}
            },
        }
    }

    local selected_monitors
    if hl.get_monitor(monitors.home.left.monitor) then
        selected_monitors = monitors.home
    elseif hl.get_monitor(monitors.work.left.monitor) then
        selected_monitors = monitors.work
    else
        selected_monitors = monitors.bare
    end
    hl.workspace_rule({
        workspace = 1,
        monitor = selected_monitors.right.monitor,
        persistent = true,
        default = true,
        layout_opts = selected_monitors.right.layout_opts,
    })
    hl.workspace_rule({
        workspace = 2,
        monitor = selected_monitors.left.monitor,
        persistent = true,
        default = true,
        layout_opts = selected_monitors.left.layout_opts,
    })
    hl.workspace_rule({
        workspace = 3,
        monitor = selected_monitors.right.monitor,
        persistent = true,
        default = false,
        layout_opts = selected_monitors.right.layout_opts,
    })
    hl.workspace_rule({
        workspace = 4,
        monitor = selected_monitors.left.monitor,
        persistent = true,
        default = false,
        layout_opts = selected_monitors.left.layout_opts,
    })
    hl.workspace_rule({
        workspace = 5,
        monitor = selected_monitors.right.monitor,
        persistent = true,
        default = false,
        layout_opts = selected_monitors.right.layout_opts,
    })
    hl.workspace_rule({
        workspace = 6,
        monitor = selected_monitors.left.monitor,
        persistent = true,
        default = false,
        layout_opts = selected_monitors.left.layout_opts,
    })
    hl.workspace_rule({
        workspace = 7,
        monitor = selected_monitors.right.monitor,
        persistent = true,
        default = false,
        layout_opts = selected_monitors.right.layout_opts,
    })
    hl.workspace_rule({
        workspace = 8,
        monitor = selected_monitors.left.monitor,
        persistent = true,
        default = false,
        layout_opts = selected_monitors.left.layout_opts,
    })
    hl.workspace_rule({
        workspace = 9,
        monitor = selected_monitors.right.monitor,
        persistent = true,
        default = false,
        layout_opts = selected_monitors.right.layout_opts,
    })
    hl.workspace_rule({
        workspace = 10,
        monitor = selected_monitors.left.monitor,
        persistent = true,
        default = false,
        layout_opts = selected_monitors.left.layout_opts,
    })
end

setup_workspaces()

hl.on("monitor.added", setup_workspaces)
hl.on("monitor.removed", setup_workspaces)
