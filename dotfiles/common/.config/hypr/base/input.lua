hl.config({
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
})

hl.device({
    name = "at-translated-set-2-keyboard",
    kb_options = "caps:swapescape",
    kb_variant = "intl",
})
hl.device({
    name = "microsoft-wired-keyboard-400",
    kb_options = "caps:swapescape",
    kb_variant = "intl",
})
