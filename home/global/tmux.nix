
{ inputs, lib, pkgs, config, outputs, ... }:
{
    programs.tmux = {
        enable = true;
        # keyMode = "vi";
        historyLimit = 100000;
        clock24 = true;
        mouse = true;
        shortcut = "a";
        terminal = "tmux-256color";
        extraConfig = ''
        set-option -ga terminal-overrides ",xterm-kitty:Tc"
        '';
    };

    home.packages = [
        pkgs.tmux
    ];
}
