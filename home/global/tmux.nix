{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}:
{
  programs.tmux = {
    enable = true;
    historyLimit = 1000000;
    clock24 = true;
    mouse = true;
    shortcut = "a";
    terminal = "tmux-256color";
    escapeTime = 0;
    extraConfig = ''
      set-option -ga terminal-overrides ",xterm-kitty:Tc"
      if-shell "test -f ~/.config/tmux/local.tmux.conf" "source-file ~/.config/tmux/local.tmux.conf"
      set-option -g automatic-rename on
      set-option -g automatic-rename-format '#{b:pane_current_command} #{b:pane_current_path}'

      set -g status-justify left
      set -g status-style "bg=black,fg=white"

      set -g pane-border-style bg=default,fg=brightblack
      set -g pane-active-border-style bg=default,fg=blue
      set -g display-panes-colour black
      set -g display-panes-active-colour brightblack

      setw -g clock-mode-colour cyan

      set -g message-style bg=brightblack,fg=cyan
      set -g message-command-style bg=brightblack,fg=cyan

      set -g status-left "#[fg=black,bg=blue,bold] #S #[fg=blue,bg=black,nobold,noitalics,nounderscore]" 
      set -g status-right "#{prefix_highlight}#[fg=brightblack,bg=black,nobold,noitalics,nounderscore]#[fg=white,bg=brightblack] %m-%d #[fg=white,bg=brightblack,nobold,noitalics,nounderscore]#[fg=white,bg=brightblack] %H:%M #[fg=cyan,bg=brightblack,nobold,noitalics,nounderscore]#[fg=black,bg=cyan,bold] #H "

      set -g window-status-format "#[fg=black,bg=brightblack,nobold,noitalics,nounderscore] #[fg=white,bg=brightblack]#I #[fg=white,bg=brightblack,nobold,noitalics,nounderscore] #[fg=white,bg=brightblack]#W #F #[fg=brightblack,bg=black,nobold,noitalics,nounderscore]"
      set -g window-status-current-format "#[fg=black,bg=cyan,nobold,noitalics,nounderscore] #[fg=black,bg=cyan]#I #[fg=black,bg=cyan,nobold,noitalics,nounderscore] #[fg=black,bg=cyan]#W #F #[fg=cyan,bg=black,nobold,noitalics,nounderscore]"
      set -g window-status-separator ""
    '';
    tmuxp.enable = false;
  };

  home.packages = [
    pkgs.tmux
  ];
}
