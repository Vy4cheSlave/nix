{ pkgs, ... }:
{
  programs.btop = {
    enable = true;
    themes = {
      catppuccin_mocha = ../conf/btop/themes/catppuccin_mocha.theme; 
    };
    settings = {
      color_theme = "catppuccin_mocha";
    };
  };
}