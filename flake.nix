{
  # Herdr binary cache
  nixConfig = {
    extra-substituters = [ "https://herdr.cachix.org" ];
    extra-trusted-public-keys = [
      "herdr.cachix.org-1:3nH7IStRsS0ASfdonA0DCRR2ZrSCeWitZ7Kwew0cR4I="
    ];
  };

  inputs = {
    # Package collection - nixpkgs unstable for latest packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # User environment manager - pinned to the same nixpkgs to avoid duplication
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixVim configuration from a separate external flake
    # Ref: https://github.com/nito-008/nix-flakes-nixvim
    nixvimConfig = {
      url = "github:nito-008/nix-flakes-nixvim";
    };

    # Terminal multiplexer for AI coding agents
    herdr = {
      url = "github:herdrdev/herdr-nix";
      # Keep upstream nixpkgs to match the derivations published to Cachix.
    };
  };

  outputs =
    inputs:
    let
      systems = "x86_64-linux"; # Target architecture
      username = "nito"; # Your Linux username (home directory will be /home/[username])

      # GitHub info
      githubUsername = "nito-008";
      githubEmail = "100199931+nito-008@users.noreply.github.com";

      # ── Optional services ──────────────────────────────────────────────────────
      # After changing, run `nixos` to apply.
      enableTailscale = false; # Zero-config mesh VPN (run `sudo tailscale up` after first enable)

      # NixOS base system configuration (boot, hardware, networking, services)
      baseModules = [
        ./nixos/configuration.nix
      ];

      # NixOS application and tool modules (packages, shell, fonts, i18n, etc.)
      nixosModules = [
        ./modules/apps.nix
      ];

      # Nixpkgs instance with allowUnfree — shared by both NixOS and home-manager
      pkgs = import inputs.nixpkgs {
        system = systems;
        config.allowUnfree = true;
      };
    in
    {
      # ── home-manager ──────────────────────────────────────────────────────────
      # User-level configuration, intentionally independent from NixOS
      homeConfigurations = {
        myHomeConfig = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
            inherit username;
          };
          modules = [
            ./home/home.nix
          ];
        };
      };

      # ── NixOS ─────────────────────────────────────────────────────────────────
      # Keep this attribute name in sync with networking.hostName.
      nixosConfigurations = {
        ibanez = inputs.nixpkgs.lib.nixosSystem {
          inherit pkgs;
          # Merge base config and app modules.
          modules = baseModules ++ nixosModules;
          specialArgs = {
            inherit inputs;
            inherit username;
            inherit githubUsername;
            inherit githubEmail;
            inherit enableTailscale;
          };
        };
      };
    };
}
