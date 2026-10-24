# NixOS-WSL host. Shared settings are in hosts/common.nix.
{ username, ... }:
{
  wsl.enable = true;
  wsl.defaultUser = username;
  networking.hostName = "nixos";
  system.stateVersion = "26.05";

  # Keep builds light on the WSL VM.
  nix.settings.max-jobs = 1;
  nix.settings.cores = 2;
  nix.settings.max-substitution-jobs = 2;

  systemd.services."user@".serviceConfig = {
    Restart = "on-failure";
    RestartSec = "2s";
  };
}
