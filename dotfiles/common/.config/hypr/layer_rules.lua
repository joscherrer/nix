hl.layer_rule({
    match = {
        namespace = "^(gtk-layer-shell|anyrun|ashell-main-layer)$",
    },
    blur = true,
    ignore_alpha = 0,
})
hl.layer_rule({
    match = {
        namespace = "vicinae",
    },
    blur = true,
    blur_popups = true,
    ignore_alpha = 0.800000,
    no_anim = true,
})
hl.layer_rule({
    match = {
        namespace = "notifications",
    },
    blur = true,
    blur_popups = true,
    ignore_alpha = 0,
})
hl.layer_rule({
    match = {
        namespace = "match:namespace launcher",
    },
    blur = true,
})
