# common/modules/watchtower/prometheus.nix
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.j3ff.watchtower.exporters.nut;
in
{
  options = {
    j3ff.watchtower.exporters.nut = {
      enable = lib.mkEnableOption "NUT Prometheus exporter service";
    };
  };

  config = lib.mkIf cfg.enable {

    services.prometheus.exporters.nut.enable = true;
    services.prometheus.exporters.nut.nutServer = "10.1.0.9";

  };
}
