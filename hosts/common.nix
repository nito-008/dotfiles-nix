# Settings shared by every host (ibanez, WSL).
# Host-specific settings live in hosts/<host>/default.nix.
{ pkgs, username, ... }:
{
  nix.settings = {
    auto-optimise-store = true; # Deduplicate identical files in the Nix store
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
  };
}
