{ pkgs, config, lib, ... }:
{
  home.packages = [
    pkgs.sketchybar
  ];

  # Основной конфиг
  home.file.".config/sketchybar/sketchybarrc".source = ../conf/bar/sketchybar/sketchybarrc;
  # Плагины (директория целиком)
  home.file.".config/sketchybar/plugins" = {
    source = ../conf/bar/sketchybar/plugins;
    recursive = true;
    executable = true; # Это принудительно сделает все файлы в папке исполняемыми
  };

  launchd.agents.sketchybar = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.sketchybar}/bin/sketchybar"
        "--config" "${config.home.homeDirectory}/.config/sketchybar/sketchybarrc"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      EnvironmentVariables = {
        CONFIG_DIR = "${config.home.homeDirectory}/.config/sketchybar";
        PATH = "/etc/profiles/per-user/${config.home.username}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
    };
  };
}
