{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default.userSettings = {
      "window.zoomLevel" = 0.8;
      "keyboard.dispatch" = "keyCode";

      "editor.fontFamily" = "JetBrainsMono Nerd Font, monospace";
      "editor.fontLigatures" = true;
      "editor.fontSize" = 15;

      "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font, monospace";
      "terminal.integrated.fontSize" = 15;
    };
  };
}
