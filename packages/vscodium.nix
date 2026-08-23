{ pkgs, ... }:
{
  programs.vscodium = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default.userSettings = {
      "update.mode" = "manual"; # manual/none
      "extensions.autoCheckUpdates" = true;
      "extensions.autoUpdate" = "off";

      "window.zoomLevel" = 0.8;
      "keyboard.dispatch" = "keyCode";

      "editor.fontFamily" = "JetBrainsMono Nerd Font, monospace";
      "editor.fontLigatures" = true;
      "editor.fontSize" = 15;

      "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font, monospace";
      "terminal.integrated.fontSize" = 15;
      "terminal.integrated.inheritEnv" = true;
      "terminal.integrated.env.osx" = {
        "__HM_SESS_VARS_SOURCED" = null;
      };

      "workbench.colorTheme" = "Dark Modern";
    };
  };
}
