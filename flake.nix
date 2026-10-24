{
  inputs = {
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

      # Nixpkgs instance with allowUnfree — shared by both NixOS and home-manager
      pkgs = import inputs.nixpkgs {
        system = systems;
        config.allowUnfree = true;
      };

      # Build a NixOS host: shared modules + home-manager + the host's own modules.
      #   hosts/common.nix   — settings shared by every host (nix, timezone, user)
      #   modules/apps.nix   — application and tool modules (packages, shell, fonts, i18n, etc.)
      #   home/home.nix      — user-level config, applied as part of the NixOS switch
      mkHost =
        hostModules:
        inputs.nixpkgs.lib.nixosSystem {
          inherit pkgs;
          specialArgs = {
            inherit inputs username githubUsername githubEmail enableTailscale;
          };
          modules = [
            ./hosts/common.nix
            ./modules/apps.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs username; };
              home-manager.users.${username} = import ./home/home.nix;
            }
          ]
          ++ hostModules;
        };
    in
    {
      # ── NixOS ─────────────────────────────────────────────────────────────────
      # Keep each attribute name in sync with that host's networking.hostName;
      # `nixos-rebuild switch --flake <repo>` picks the one matching the hostname.
      nixosConfigurations = {
        # Bare-metal server
        ibanez = mkHost [ ./hosts/ibanez ];

        # NixOS-WSL
        nixos = mkHost [
          inputs.nixos-wsl.nixosModules.default
          ./hosts/wsl
        ];
      };
    };
}
