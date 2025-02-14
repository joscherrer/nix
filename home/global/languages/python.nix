{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    uv
  ];
  xdg.configFile."uv/uv.toml" = {
    text = ''
      python-preference = "only-system"
    '';
  };
}
