{ pkgs, ... }:
{
  home.packages = [
    pkgs.helix
  ];

  xdg.configFile."helix/config.toml".source = ../conf/helix/config.toml;
}