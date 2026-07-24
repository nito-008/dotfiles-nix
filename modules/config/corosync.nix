{ pkgs, ... }:
{
  # ── Corosync QNetd ───────────────────────────────────────────────────────────
  # qnetd runs outside the Proxmox cluster and provides its quorum vote.
  # NSS tools supplies certutil, which corosync-qnetd-certutil invokes when pvecm
  # initializes the TLS certificate database over SSH.
  environment.systemPackages = [
    pkgs.corosync-qdevice
    pkgs.nss.tools
  ];

  # pvecm initializes this state as root. Keep qnetd root-owned for compatibility
  # with that workflow; the NSS database remains persistent across rebuilds.
  systemd.tmpfiles.rules = [
    "d /etc/corosync 0755 root root -"
    "d /etc/corosync/qnetd 0755 root root -"
    "d /etc/corosync/qnetd/nssdb 0700 root root -"
  ];

  systemd.services.corosync-qnetd = {
    description = "Corosync QDevice Network daemon";
    wantedBy = [ "multi-user.target" ];
    requires = [ "network-online.target" ];
    after = [ "network-online.target" ];

    serviceConfig = {
      Type = "notify";
      User = "root";
      Group = "root";
      ExecStart = "${pkgs.corosync-qdevice}/bin/corosync-qnetd -f";

      RuntimeDirectory = "corosync-qnetd";
      RuntimeDirectoryMode = "0770";

      # The first starts fail until pvecm creates the NSS database. Retrying lets
      # qnetd recover automatically as soon as certificate initialization ends.
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };

  # The qnetd endpoint is used through the existing NetworkManager-managed LAN.
  # This does not declare or change the address assigned to enp1s0.
  networking.firewall.interfaces."enp1s0".allowedTCPPorts = [ 5403 ];
}
