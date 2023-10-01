{ colorlib, lib, }: rec {
  colors = import ./colors.nix;
  # #RRGGBB
  xcolors = lib.mapAttrs (_: colorlib.x) colors;
  # rgba(,,,) colors (css)
  rgbaColors = lib.mapAttrs (_: colorlib.rgba) colors;

  browser = "brave";

  launcher = "anyrun";

  # linuxmobile font -> AestheticIosevka Nerd Font Mono
  terminal = {
    font = "CartographCF Nerd Font";
    name = "wezterm";
    opacity = 1.0;
    size = 9;
  };

  # TODO: Change this later
  wallpaper = builtins.fetchurl {
    url =
      "https://w.wallhaven.cc/full/x6/wallhaven-x6919l.jpg";
    sha256 = "sha256:1zy78h1a8r3frx4yfablnzj8x0wvly9zhqgfl6mg0ab4vcgk055d";
  };
}