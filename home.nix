{ pkgs, lib, ... }:
{
  imports = [
    ./modules/proxy-pac.nix
    ./packages/btop.nix
    ./packages/git.nix
    ./packages/ghostty.nix
    ./packages/aerospace.nix
    ./packages/sketchybar.nix
    ./packages/vscodium.nix
    ./packages/zsh.nix
    ./packages/helix.nix
  ];

  home.username = "vch";
  home.homeDirectory = lib.mkForce /Users/vch;

  # Важно: НЕ МЕНЯТЬ
  home.stateVersion = "25.11";

  home.packages = [
    # cli
    pkgs.git
    pkgs.openvpn
    pkgs.tmux
    pkgs.gnumake

    # gui
    pkgs.obsidian
    pkgs.codex
    pkgs.zoom-us
    # pkgs.whisky # (не поддерживается) # аналог bottles/port_proton на linux

    # manual gui
    (pkgs.callPackage ./packages/throne-bin.nix { })
    # (pkgs.callPackage ./packages/zen-browser-bin.nix { })
    
    # DIY
    # pkgs.blender

    # fonts
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.jetbrains-mono

    # X11 support on macOS
    # pkgs.xquartz
    # pkgs.quartz-wm
    # pkgs.pkgsx86_64Darwin.rofi
  ];

  # Чтобы CLI-программы видели шрифт
  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;
}
