{ pkgs, lib, ... }:
{
  imports = [
    ./modules/proxy-pac.nix
  ];

  home.username = "vch";
  home.homeDirectory = lib.mkForce /Users/vch;

  # Важно: НЕ МЕНЯТЬ
  home.stateVersion = "25.11";

  home.packages = [
    pkgs.git
    pkgs.obsidian
    pkgs.vscodium
    pkgs.codex
    pkgs.ghostty-bin
    pkgs.openvpn
    
    # DIY
    # pkgs.blender
    (pkgs.callPackage ./throne-bin.nix { })
  ];

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Vy4cheSlave";
        email = "slav.subocheff@yandex.ru";
      };

      init.defaultBranch = "main";
      # pull.rebase = true;
      # core.editor = "code --wait";

      # опционально: удобные алиасы
      alias = {
        # st = "status -sb";
        # co = "checkout";
        # br = "branch";
        # lg = "log --oneline --decorate --graph --all";
      };
    };
  };

  programs.home-manager.enable = true;
}
