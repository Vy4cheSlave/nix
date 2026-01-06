{ pkgs, ... }:
{
  home.packages = [
    pkgs.aerospace
  ];

  home.file.".aerospace.toml".source = ../conf/wm/aerospace/.aerospace.toml;
}