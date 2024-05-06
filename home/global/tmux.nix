
{ inputs, lib, pkgs, config, outputs, ... }:
{
    programs.tmux = {
        enable = true;
        historyLimit = 100000;
        clock24 = true;
        mouse = true;
        shortcut = "a";
        terminal = "tmux-256color";
        extraConfig = ''
        set-option -ga terminal-overrides ",xterm-kitty:Tc"
        if-shell "test -f ~/.config/tmux/local.tmux.conf" "source-file ~/.config/tmux/local.tmux.conf"
        '';
        tmuxp.enable = true;
    };

    home.packages = [
        pkgs.tmux
    ];
}
