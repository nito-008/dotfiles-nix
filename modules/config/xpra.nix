{ pkgs, ... }:
{
  systemd.user.services.xpra = {
    description = "Xpra virtual display";
    wantedBy = [ "default.target" ];
    path = [
      pkgs.xauth
      pkgs.xkbcomp
      pkgs.setxkbmap
    ];

    serviceConfig = {
      ExecStart = "${pkgs.xpra}/bin/xpra seamless :100 --daemon=no --systemd-run=no --mdns=no --bind-tcp=127.0.0.1:14500 --tcp-auth=none --html=on";
      Restart = "on-failure";
      RestartSec = "3s";
    };
  };
}
