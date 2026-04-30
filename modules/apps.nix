{
  inputs,
  pkgs,
  lib,
  enableTailscale,
  enableWireGuard,
  ...
}:
{
  imports = [
    ./config/commands.nix # General CLI utilities and system tools
    ./config/fonts.nix # Font packages and fontconfig defaults
    ./config/git.nix # Git, GitHub CLI, and repository management tools
    ./config/i18n.nix # Locale, fcitx5 input method, and SKK dictionaries
    ./config/docker.nix # Docker runtime and CLI tools (docker-compose, lazydocker)
    ./config/languages.nix # Programming language compilers and runtimes
    ./config/nix-ld.nix # Dynamic linker compatibility for pre-built binaries
    ./config/starship.nix # Starship cross-shell prompt
    ./config/zsh.nix # Zsh shell with Oh My Zsh, aliases, and custom functions
  ]
  # Optional service modules — toggled via booleans in flake.nix.
  # When false, the module is not imported at all (no packages, no firewall rules).
  ++ lib.optionals enableTailscale [ ./config/tailscale.nix ]
  ++ lib.optionals enableWireGuard [ ./config/wireguard.nix ];
  environment.systemPackages = with pkgs; [
    # TLS/SSL toolkit and certificate management
    openssl

    # AI assistant CLIs
    codex
    claude-code

    # Build automation
    gnumake

    # AppImage launcher - run AppImage binaries without extraction
    appimage-run

    # Text editors
    inputs.nixvimConfig.packages.${pkgs.stdenv.hostPlatform.system}.default # NixVim configuration from the external flake
    nano # Minimal terminal editor

    # Typst - modern typesetting system (alternative to LaTeX)
    typst

    # HTTP clients
    httpie # User-friendly HTTP client for the terminal

    distrobox # Run any Linux distro inside a container

    # direnv integration - auto-load .envrc when entering a directory
    nix-direnv # Nix-specific direnv extension with faster evaluations
    direnv # Shell environment loader
  ];
}
