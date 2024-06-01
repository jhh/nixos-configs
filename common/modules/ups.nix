{ config, lib, pkgs, ... }:
{
  options = {
    j3ff.ups.enable = lib.mkEnableOption "UPS monitoring";
  };

  config = lib.mkIf config.j3ff.ups.enable {

    age.secrets.upsmon.file = ../../secrets/upsmon.conf.age;

    power.ups = {
      enable = true;
      mode = "netclient";
      upsmon.monitor.ups = {
        user = "upsmon_remote";
        type = "slave";
        system = "ups@10.1.0.9";
        passwordFile = config.age.secrets.upsmon.path;
      };
    };

    systemd.services.upsd.enable = false;
    systemd.services.upsdrv.enable = false;

  };
}
