# common/services/prometheus.nix
{ config, lib, pkgs, ... }:
{
  options = {
    j3ff.prometheus.enable = lib.mkEnableOption "Prometheus monitoring";
  };

  config = lib.mkIf config.j3ff.prometheus.enable {
    services.prometheus = {
      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" ];
          port = 9002;
        };
      };
    };
  };
}
