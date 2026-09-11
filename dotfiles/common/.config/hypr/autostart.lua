-- Autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("thunar --daemon")
    hl.exec_cmd(
        "systemd-inhibit --who=Hyprland config --why=wlogout keybind --what=handle-power-key --mode=block sleep infinity & echo $! > /tmp/.hyprland-systemd-inhibit")
    hl.exec_cmd("openvpn3-indicator")
    hl.exec_cmd("vicinae server")
end)

-- Shutdown
hl.on("hyprland.shutdown", function()
    hl.exec_cmd("kill -9 $(cat /tmp/.hyprland-systemd-inhibit)")
end)
