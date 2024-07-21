{ inputs, lib, pkgs, config, outputs, ... }:
{

  home.file = {
    ".local/opt/jdk8".source = pkgs.jdk8;
    ".local/opt/jdk11".source = pkgs.jdk11;
    ".local/opt/jdk17".source = pkgs.jdk17;
    ".local/opt/jdk21".source = pkgs.jdk21;
  };

  home.packages = with pkgs; [
    gradle
    maven
    kotlin
    kotlin-native
    kotlin-language-server
  ];
}
