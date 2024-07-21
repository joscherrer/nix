{ pkgs, ... }:
{
    home.packages = with pkgs; [
        # JS/TS
        unstable.nodejs
        nodePackages.typescript
        yarn
    ];
}
