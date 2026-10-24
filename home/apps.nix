{
  pkgs,
  ...
}:
{
  imports = [
  ];
  # User-level packages managed by home-manager
  home.packages = with pkgs; [
  ];

  # Generate ~/.zshrc so zsh-newuser-install doesn't run on every shell.
  # The actual zsh config (oh-my-zsh, aliases, etc.) lives in modules/config/zsh.nix (/etc/zshrc).
  programs.zsh.enable = true;
}
