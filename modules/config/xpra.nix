{ pkgs, ... }:
{
  systemd.user.services.xpra = {
    description = "Xpra virtual display";
    wantedBy = [ "default.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.xpra}/bin/xpra seamless :100 --daemon=no --systemd-run=no --mdns=no";
      Restart = "on-failure";
      RestartSec = "3s";
    };
  };
}
