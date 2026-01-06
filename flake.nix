{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nix-homebrew, ... }:
  let
    configuration = { pkgs, ... }: {
      nixpkgs.config = {
        allowUnfree = true;
        # allowUnsupportedSystem = true;
      };

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [
        pkgs.vim
      ];

      system.primaryUser = "vch";
      users.users.vch = {
        name = "vch";
        home = "/Users/vch";
      };

      nix.enable = false;
      programs.zsh.enable = true;

      # Necessary for using flakes on this system.
      # nix.settings.experimental-features = "nix-command flakes";

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#vch
    darwinConfigurations."vch" = nix-darwin.lib.darwinSystem {
      modules = [
        # Основной конфиг
        configuration

        # Подключаем внешние файлы конфигурации
        ./brew.nix
        ./darwin.nix
        ./modules/proxy-pac-darwin.nix

        # Home Manager через nix-darwin
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup"; # позволяет перезаписывать существующие конфиги в ~/.config
          home-manager.users.vch = import ./home.nix;
        }

        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            user = "vch";
            autoMigrate = true;
          };
        }
      ];
    };
  };
}
