{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    stable.dotnetCorePackages.sdk_10_0_2xx
    stable.roslyn-ls
    stable.rzls
  ];

  home.sessionVariables = {
    DOTNET_ROOT = "${pkgs.stable.dotnetCorePackages.sdk_10_0_2xx}/share/dotnet";
  };
}
