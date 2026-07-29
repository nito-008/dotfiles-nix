{
  inputs,
  pkgs,
  lib,
  enableTailscale,
  ...
}:
let
  stablePkgs = import inputs.nixpkgs_25_11 {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  imports = [
    ./config/commands.nix # General CLI utilities and system tools
    ./config/corosync.nix # Corosync qnetd quorum service for Proxmox
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
  ++ lib.optionals enableTailscale [ ./config/tailscale.nix ];
  environment.systemPackages = with pkgs; [
    # TLS/SSL toolkit and certificate management
    openssl

    # AI assistant CLIs
    codex
    claude-code

    # Agent multiplexer
    inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.herdr

    # Build automation
    gnumake

    # AppImage launcher - run AppImage binaries without extraction
    appimage-run

    # Text editors
    inputs.nixvimConfig.packages.${pkgs.stdenv.hostPlatform.system}.default # Custom NixVim configuration
    nano # Minimal terminal editor

    # Typst - modern typesetting system (alternative to LaTeX)
    typst

    # Network and media CLIs
    httpie # User-friendly HTTP client for the terminal
    stablePkgs.yt-dlp # Video/audio downloader for supported media sites

    distrobox # Run any Linux distro inside a container

    # direnv integration - auto-load .envrc when entering a directory
    nix-direnv # Nix-specific direnv extension with faster evaluations
    direnv # Shell environment loader

    # virtual x11 display
    xpra
  ];
}
