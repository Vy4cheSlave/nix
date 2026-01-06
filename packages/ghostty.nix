{ pkgs, ... }:
{
  home.packages = [
    pkgs.ghostty-bin
  ];

  xdg.configFile."ghostty/config".source = ../conf/ghostty/config;
  xdg.configFile."ghostty/shaders".source = ../conf/ghostty/shaders;
}