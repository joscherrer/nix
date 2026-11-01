-- Monitor layouts are per host: dotfiles/hosts/<hostname>/hypr/host.lua is
-- installed as host.lua next to this config (session and greeter). It
-- applies its hl.monitor rules when loaded and returns the workspace sets
-- used by workspaces.lua. Hosts without one get Hyprland's default layout.
if package.searchpath("host", package.path) then
    require("host")
end
