
{ inputs, lib, pkgs, config, outputs, ... }:
{
    programs.tmux = {
        enable = true;
        keyMode = "vi";
        historyLimit = 100000;
        clock24 = true;
        mouse = true;
        prefix = "C-a";
    };
}
