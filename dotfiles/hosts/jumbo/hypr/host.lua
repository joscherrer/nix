-- jumbo: two Acer V277 E, the left one rotated, plus an optional AOC.
local acer_left = "desc:Acer Technologies V277 E 842614D663W01"
local acer_right = "desc:Acer Technologies V277 E 842614EC23W01"
local aoc = "desc:AOC 28E850"

hl.monitor({ output = acer_right, mode = "1920x1080@100", position = "1080x160", scale = 1 })
hl.monitor({ output = acer_left, mode = "1920x1080@100", position = "0x0", scale = "auto", transform = 1 })

hl.workspace_rule({ workspace = 11, monitor = aoc, persistent = true, default = true })

return {
    workspace_sets = {
        {
            left = { monitor = acer_left, layout_opts = { orientation = "top" } },
            right = { monitor = acer_right },
        },
    },
}
