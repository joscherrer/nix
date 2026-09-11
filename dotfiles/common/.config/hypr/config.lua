hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
    master = {
        mfact = 0.660000,
        new_status = "slave",
    },
    misc = {
        disable_hyprland_logo = true,
        focus_on_activate = true,
    },
    general = {
        border_size = 2,
        gaps_in = 5,
        gaps_out = 5,
        layout = "master",
        col = {
            active_border = { colors = { "rgb(101618)", "rgb(303b41)" }, angle = 270 },
            inactive_border = { colors = { "rgb(22292d)", "rgb(85b7b0)" }, angle = 270 },
        },
    },
    input = {
        touchpad = {
            natural_scroll = false,
        },
        accel_profile = "flat",
        follow_mouse = 2,
        kb_layout = "us",
        kb_options = "compose:ralt",
        repeat_delay = 250,
        repeat_rate = 60,
        sensitivity = 0,
    },
    animations = {
        enabled = true,
    },
    binds = {
        movefocus_cycles_fullscreen = true,
    },
    debug = {
        disable_logs = false,
    },
    decoration = {
        blur = {
            brightness = 1.2,
            contrast = 1.1,
            ignore_opacity = true,
            new_optimizations = true,
            noise = 0.1,
            passes = 3,
            size = 6,
            xray = true,
        },
        shadow = {
            color = "rgba(00000099)",
            enabled = true,
            -- ignore_window = true,
            offset = "0 8",
            range = 50,
            render_power = 3,
        },
        rounding = 5,
    },
    dwindle = {
        preserve_split = true,
        -- pseudotile = true,
    },
})
