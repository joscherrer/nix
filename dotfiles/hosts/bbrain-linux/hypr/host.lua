-- bbrain-linux (desktop): rotated Dell on the left, LG ultrawide on the right.
local dell = "desc:Dell Inc. DELL U2415 7MT0167B2YNL"
local lg = "desc:LG Electronics LG HDR WQHD+ 205NTCZ8L675"

hl.monitor({ output = lg, mode = "3840x1600@144", position = "1200x160", scale = 1.25 })
hl.monitor({ output = dell, mode = "1920x1200@60", position = "0x0", scale = "auto", transform = 1 })
hl.monitor({ output = "desc:AOC 28E850", disabled = true })

return {
    workspace_sets = {
        {
            left = { monitor = dell, layout_opts = { orientation = "top" } },
            right = { monitor = lg },
        },
    },
}
