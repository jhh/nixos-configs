{ config, lib, pkgs, ... }:
{
  options = {
    j3ff.ups.enable = lib.mkEnableOption "UPS monitoring";
  };

  config = lib.mkIf config.j3ff.ups.enable {

    power.ups = {
      enable = true;
      mode = "netclient";
    };

    systemd.services.upsd.enable = false;
    systemd.services.upsdrv.enable = false;

    systemd.services.upsmon.preStart = ''
      ln -sf /root/upsmon.conf /etc/nut/upsmon.conf
    '';
  };
}
