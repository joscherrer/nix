{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    stable.dotnetCorePackages.sdk_10_0
    stable.roslyn-ls
    stable.rzls
    stable.patchelf
  ];

  home.sessionVariables = {
    DOTNET_ROOT = "${pkgs.stable.dotnetCorePackages.sdk_10_0}/share/dotnet";
  };
}
