-- rds (laptop): internal panel, plus the home or work dock monitors.
local dell_home = "desc:Dell Inc. DELL U2415 7MT0167B2YNL"
local lg_home = "desc:LG Electronics LG HDR WQHD+ 205NTCZ8L675"
local lenovo_left = "desc:Lenovo Group Limited L27qe UTP02GR9"
local lenovo_right = "desc:Lenovo Group Limited L27qe UTP02GR4"

hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = 1 })
hl.monitor({ output = dell_home, mode = "preferred", position = "1920x0", scale = "auto", transform = 1 })
hl.monitor({ output = lg_home, mode = "highrr", position = "auto-center-right", scale = 1 })
hl.monitor({ output = lenovo_left, mode = "preferred", position = "1920x0", scale = "auto", transform = 1 })
hl.monitor({ output = lenovo_right, mode = "preferred", position = "auto-center-right", scale = 1 })

-- First set whose left monitor is connected wins (see workspaces.lua).
return {
    workspace_sets = {
        {
            left = { monitor = dell_home, layout_opts = { orientation = "top" } },
            right = { monitor = lg_home },
        },
        {
            left = { monitor = lenovo_left, layout_opts = { orientation = "top" } },
            right = { monitor = lenovo_right },
        },
        {
            left = { monitor = "eDP-1" },
            right = { monitor = "DP-1" },
        },
    },
}
