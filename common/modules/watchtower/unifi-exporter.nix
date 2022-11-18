# common/modules/watchtower/prometheus.nix
{ config, lib, pkgs, ... }:
let
  cfg = config.j3ff.watchtower.exporters.unifi;
in
{
  options = {
    j3ff.watchtower.exporters.unifi = {
      enable = lib.mkEnableOption "Unifi Prometheus exporter service";
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.unifi_passwd = {
      file = ../secrets/unifi_passwd.age;
      owner = "${toString config.services.prometheus.exporters.unifi-poller.user}";
      group = "${toString config.services.prometheus.exporters.unifi-poller.group}";
    };

    services.prometheus.exporters.unifi-poller = {
      enable = true;
      controllers = [
        {
          user = "unpoller";
          pass = config.age.secrets.unifi_passwd.path;
          url = "https://10.1.0.1";
          verify_ssl = false;
        }
      ];
    };
  };
}
