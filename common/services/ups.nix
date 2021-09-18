{ config, lib, pkgs, ... }:
{

  environment.systemPackages = [
    pkgs.nut
  ];

  power.ups = {
    enable = true;
    mode = "netclient";
  };

  systemd.services.upsd.enable = false;
  systemd.services.upsdrv.enable = false;

  systemd.services.upsmon.preStart = ''
    ln -sf /root/upsmon.conf /etc/nut/upsmon.conf
  '';
}
