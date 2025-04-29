# common/modules/watchtower/grafana.nix
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.j3ff.watchtower.grafana;
in
{
  options = {
    j3ff.watchtower.grafana = {
      enable = lib.mkEnableOption "Grafana dashboard server";

      domain = lib.mkOption {
        type = lib.types.str;
        default = "grafana.j3ff.io";
        description = "DNS name of Grafana server.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.grafana = {
      enable = true;
      settings.server = {
        domain = cfg.domain;
        http_port = 2342;
        http_addr = "127.0.0.1";
      };
      settings.panels.disable_sanitize_html = true;
      declarativePlugins = with pkgs.grafanaPlugins; [
        grafana-piechart-panel
        grafana-clock-panel
      ];
    };

    services.nginx.virtualHosts.${cfg.domain} = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
        proxyWebsockets = true;
      };
    };
  };
}
