{ self, inputs, outputs, config, pkgs, lib, ... }:
{
  networking.localHostName = "bbrain-mbp";

  environment.systemPackages = [
    pkgs.alacritty
    pkgs.discord
    pkgs.skhd
  ];

  services.nix-daemon.enable = true;

  fonts.fontDir.enable = true;
  fonts.fonts = [
    pkgs.nerdfonts
  ];

  security.pam.enableSudoTouchIdAuth = true;

  services.dnsmasq = {
    enable = true;
    addresses = {
      test = "127.0.0.1";
    };
  };

  services.skhd = {
      enable = true;
      skhdConfig = ''
        cmd + shift - p : if [ "$(yabai -m config layout)" = "float" ]; then yabai -m config layout bsp; else yabai -m config layout float; fi
        cmd + 1 : yabai -m space --focus 1
        cmd + 2 : yabai -m space --focus 2
        cmd + 3 : yabai -m space --focus 3
        cmd + 4 : yabai -m space --focus 4
        cmd + 5 : yabai -m space --focus 5
      '';
  };

  # services.yabai.enable = true;
  # services.yabai.enableScriptingAddition = true;

  system.defaults = {
    ".GlobalPreferences" = {
      "com.apple.mouse.scaling" = -1.0;
    };
    NSGlobalDomain = {
      "com.apple.swipescrolldirection" = true;
      KeyRepeat = 1;
      InitialKeyRepeat = 10;
      NSAutomaticCapitalizationEnabled = false;
    };
    dock.mineffect = "scale";
  };

  system.activationScripts.applications.text = ''
    echo "Creating /Applications/Nix Aliases"
    mkdir -p "/Applications/Nix Aliases"

    falias() {
      local src
      src="$(readlink "$1")"
      dst_dir="$2"
      dst_name="$(basename "$src")"
      dst="$dst_dir/$dst_name"
      echo falias "$src" "$2"
      [ -f "$dst" ] && rm -rf "$dst"
      osascript - "$src" "$dst_dir" <<EOF
        on run argv
          set src to POSIX file (item 1 of argv)
          set nix_apps to POSIX file (item 2 of argv)
          tell application "Finder"
            make alias file to src at nix_apps
            set name of result to name of (info for src)
          end tell
        end run
    EOF
    }
    find ${config.system.build.applications}/Applications -type l -name '*.app' -depth 1 -print0 \
      | while IFS= read -r -d "" file; do falias "$file" '/Applications/Nix Aliases'; done
  '';

  # https://github.com/nix-community/home-manager/issues/4026
  users.users.jscherrer.home = "/Users/jscherrer";

  homebrew.enable = true;
  homebrew.casks = [
    "maccy"
    "easy-move-plus-resize"
    "unnaturalscrollwheels"
    "alfred"
    "rectangle"
    "hiddenbar"
    "google-chrome"
    "podman-desktop"
    "docker"
    "alt-tab"
    "box-drive"
    "teamviewer"
    "nrlquaker-winbox"
    "nightfall"
    "kitty"
    "bluesnooze"
    "kitty"
    "obsidian"
  ];

  homebrew.brews = [
    "tiger-vnc"
    "koekeishiya/formulae/yabai"
    "openjdk@17"
  ];

  homebrew.onActivation.autoUpdate = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.jscherrer = import "${self}/home/jscherrer/bbrain-mbp.nix";
    extraSpecialArgs = { inherit inputs outputs; };
  };

}
