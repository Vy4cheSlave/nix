{ pkgs, lib, ... }:
{
  imports = [
    # ./modules/proxy-pac.nix
    ./packages/btop.nix
    ./packages/git.nix
    ./packages/ghostty.nix
    ./packages/aerospace.nix
    ./packages/sketchybar.nix
    ./packages/vscodium.nix
    ./packages/zsh.nix
    ./packages/helix.nix
    ./packages/tmux.nix
    # ./packages/go.nix
    ./packages/librefox.nix
  ];

  home.username = "vch";
  home.homeDirectory = lib.mkForce /Users/vch;

  # Важно: НЕ МЕНЯТЬ
  home.stateVersion = "25.11";

  home.packages = [
    # cli
    pkgs.git
    pkgs.openvpn
    pkgs.gnumake
    pkgs.bat
    pkgs.poppler-utils # PDF rendering library
    pkgs.ripgrep
    pkgs.ffmpeg
    # pkgs.clang
    # pkgs.sdl3
    # pkgs.wgpu-native

    # РАБота
    pkgs.python311
    pkgs.file
    pkgs.grpcurl
    pkgs.nodejs
    pkgs.k6

    # gui
    pkgs.obsidian
    pkgs.codex
    # pkgs.zoom-us
    # pkgs.whisky # (не поддерживается) # аналог bottles/port_proton на linux
    # pkgs.qbittorrent
    pkgs.mpv-unwrapped # pkgs.mpv pkgs.yt-dlp # на MacOS не собирается
    # pkgs.handbrake
    # pkgs.kdenlive

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

  # для переменных окружения очень полезная тема (настроена вроде)
  home.sessionVariables = {
    DYLD_LIBRARY_PATH = "${pkgs.file}/lib";
    MAGIC = "${pkgs.file}/share/misc/magic.mgc";
  };

  # Чтобы CLI-программы видели шрифт
  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;
}
