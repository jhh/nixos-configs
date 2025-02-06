# common/modules/watchtower/prometheus.nix
{ config, lib, ... }:
let
  cfg = config.j3ff.watchtower.exporters.pihole;
in
{
  options = {
    j3ff.watchtower.exporters.pihole = {
      enable = lib.mkEnableOption "Pihole Prometheus exporter service";
    };
  };

  config = lib.mkIf cfg.enable {
    services.prometheus.exporters.pihole = {
      enable = true;
      piholeHostname = "10.1.0.2";
    };
  };
}
