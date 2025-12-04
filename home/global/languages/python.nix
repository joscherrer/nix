{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    uv
    # python3
  ];
  xdg.configFile."uv/uv.toml" = {
    text = ''
      python-preference = "only-system"
    '';
  };
}
