{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    jsonnet-language-server
  ];
}
