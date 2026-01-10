{ pkgs, ... }:
{
  home.packages = [
    pkgs.tmux
  ];

  xdg.configFile."tmux/tmux.conf".source = ../conf/tmux/tmux.conf;
}