-- hl.window_rule({
--     name             = "notion-no-fullscreen",
--     match            = {
--         title = "^(notion|notion-calendar)$",
--     },
--     fullscreen_state = { -1, 2 },
-- })
hl.window_rule({
    name    = "terminal-opacity-90",
    match   = {
        class = "^(org.wezfurlong.wezterm|Alacritty)$",
    },
    opacity = "0.90 0.90",
})
hl.window_rule({
    name    = "gnome-system-monitor-opacity-100",
    match   = {
        class = "^(org.gnome.SystemMonitor)$",
    },
    opacity = "1 1",
})
hl.window_rule({
    name    = "brave-opacity-90",
    match   = {
        class = "^(Brave-browser|brave-browser)$",
    },
    opacity = "0.90 0.90",
})
hl.window_rule({
    name         = "brave-inhibit-idle-on-fullscreen",
    match        = {
        class = "^(Brave-browser|brave-browser)$",
    },
    idle_inhibit = "fullscreen",
})
hl.window_rule({
    name         = "firefox-zen-opacity-95-inhibit-idle-on-fullscreen",
    match        = {
        class = "^(firefox|zen)$",
    },
    idle_inhibit = "fullscreen",
    opacity      = "0.95 0.95",
})
hl.window_rule({
    name    = "steam-opacity-80",
    match   = {
        class = "^(Steam|steam|steamwebhelper)$",
    },
    opacity = "0.80 0.80",
})
hl.window_rule({
    name    = "spotify-opacity-80",
    match   = {
        class = "^(Spotify)$",
    },
    opacity = "0.80 0.80",
})
hl.window_rule({
    name    = "vscode-opacity-95-90",
    match   = {
        class = "^(Code|code-url-handler)$",
    },
    opacity = "0.95 0.90",
})
hl.window_rule({
    name    = "file-tools-opacity-80",
    match   = {
        class = "^(thunar|file-roller|nwg-look|qt5ct)$",
    },
    opacity = "0.80 0.80",
})
hl.window_rule({
    name    = "chat-apps-opacity",
    match   = {
        class = "^(discord|org.telegram.desktop)$",
    },
    opacity = "0.80 0.80",
})
hl.window_rule({
    name    = "webcord-opacity-100",
    match   = {
        class = "^(WebCord)$",
    },
    opacity = "1 1",
})
hl.window_rule({
    name    = "pavucontrol-float-opacity-80-70",
    match   = {
        class = "^(pavucontrol)$",
    },
    float   = true,
    opacity = "0.80 0.70",
})
hl.window_rule({
    name    = "polkit-agent-float-opacity-80-70",
    match   = {
        class = "^(org.kde.polkit-kde-authentication-agent-1)$",
    },
    float   = true,
    opacity = "0.80 0.70",
})
hl.window_rule({
    name      = "spotify-title-workspace-9-silent-tile-opacity-80",
    match     = {
        title = "^(Spotify)$",
    },
    opacity   = "0.80 0.80",
    tile      = true,
    workspace = "9 silent",
})
hl.window_rule({
    name  = "float-media-viewer-and-volume-control",
    match = {
        title = "^(Media viewer|Volume Control)$",
    },
    float = true,
})
hl.window_rule({
    name    = "picture-in-picture-float-no-blur-opacity-100",
    match   = {
        title = "^(Picture-in-Picture)$",
    },
    float   = true,
    no_blur = true,
    opacity = "1.0 1.0",
})
hl.window_rule({
    name  = "float-viewnior",
    match = {
        class = "^(Viewnior)$",
    },
    float = true,
})
hl.window_rule({
    name  = "devtools-float",
    match = {
        title = "^(DevTools)$",
    },
    float = true,
})
hl.window_rule({
    name  = "generic-dialogs-float",
    match = {
        class = "^(file_progress|confirm|dialog|download|notification|error|confirmreset)$",
    },
    float = true,
})
hl.window_rule({
    name  = "common-dialog-titles-float",
    match = {
        title = "^(Open File|branchdialog|Confirm to replace files|File Operation Progress)$",
    },
    float = true,
})
hl.window_rule({
    name  = "qalculate-qt-float",
    match = {
        class = "io.github.Qalculate.qalculate-qt",
    },
    float = true,
})
hl.window_rule({
    name  = "openvpn3-indicator",
    match = {
        class = "^(.openvpn3-indicator.*)$",
    },
    float = true,
})
hl.window_rule({
    name  = "blueman-manager-float",
    match = {
        class = "^(.blueman-manager-wrapped)$",
    },
    float = true,
})
hl.window_rule({
    name      = "no-shadow-on-non-floating-windows",
    match     = {
        float = 0,
    },
    no_shadow = true,
})
hl.window_rule({
    name      = "discord-webcord-to-workspace-4",
    match     = {
        title = "^(.*(Disc|WebC)ord.*)$",
    },
    workspace = "4",
})
hl.window_rule({
    name      = "firefox-zen-to-workspace-2-firefox-title",
    match     = {
        class = "^(firefox|zen)$",
        title = "^(Mozilla Firefox)$",
    },
    workspace = "2",
})
hl.window_rule({
    name       = "avatar-app-fullscreen-to-workspace-8",
    match      = {
        initial_class = "^(.*com.jumbomana.avatar.*)$",
    },
    fullscreen = true,
    workspace  = "8",
})
hl.window_rule({
    name         = "idle-inhibit-on-focus-mpv-and-windows-exe",
    match        = {
        class = "^(mpv|.+exe)$",
    },
    idle_inhibit = "focus",
})
hl.window_rule({
    name         = "idle-inhibit-on-focus-youtube-in-firefox-zen",
    match        = {
        class = "^(firefox|zen)$",
        title = "^(.*YouTube.*)$",
    },
    idle_inhibit = "focus",
})
hl.window_rule({
    name   = "jetbrains-center-confirm-open-splash",
    match  = {
        class = "^(.*jetbrains.*)$",
        title = "^(Confirm Exit|Open Project|win424|win201|splash)$",
    },
    center = true,
})
hl.window_rule({
    name  = "jetbrains-splash-size-640x400",
    match = {
        class = "^(.*jetbrains.*)$",
        title = "^(splash)$",
    },
    size  = { 640, 400 },
})
hl.window_rule({
    name             = "xwaylandvideobridge-invisible-no-input-no-effects",
    match            = {
        class = "^(xwaylandvideobridge)$",
    },
    no_anim          = true,
    no_blur          = true,
    no_focus         = true,
    no_initial_focus = true,
    no_shadow        = true,
    opacity          = "0.0 override 0.0 override",
})
hl.window_rule({
    name         = "fullscreen-border-color-accent",
    match        = {
        fullscreen = 1,
    },
    border_color = "rgb(e76365) rgb(e76365)",
})
hl.window_rule({
    name      = "kitty-dropdown-to-special-terminal-workspace",
    match     = {
        class = "(kitty-dropdown)",
    },
    workspace = "special:terminal",
})
hl.window_rule({
    name      = "gmail workspace 2",
    match     = {
        initial_title = "^(Gmail)$",
    },
    workspace = "2",
})
hl.window_rule({
    name      = "calendar workspace 4",
    match     = {
        initial_title = "^(Google Calendar)$",
    },
    workspace = "4",
})
hl.window_rule({
    name      = "chat workspace 6",
    match     = {
        initial_title = "^(Google Chat)$",
    },
    workspace = "6",
})
hl.window_rule({
    name      = "terminal dropdown",
    match     = {
        class = "(kitty-dropdown)",
    },
    workspace = "special:terminal",
})
