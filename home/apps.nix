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
}