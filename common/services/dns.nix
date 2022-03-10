{ config, lib, pkgs, ... }:
{
  options = {
    j3ff.mdns.enable = lib.mkEnableOption "MDNS resolving";
  };

  config =
    let
      cfg = config.j3ff.mdns;
    in
    {
      networking.useHostResolvConf = false;
      services.resolved = {
        enable = true;
        dnssec = "false";
        llmnr = lib.boolToString cfg.enable;
        domains = [
          "lan.j3ff.io"
        ];
      };

      services.avahi = {
        enable = cfg.enable;
        nssmdns = true;
        publish = {
          enable = true;
          addresses = true;
          hinfo = true;
          userServices = true;
          workstation = true;
        };
        extraServiceFiles = {
          ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
        };
      };
    };
}
