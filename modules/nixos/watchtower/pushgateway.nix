# common/modules/watchtower/alertmanager.nix
{ config, lib, ... }:
let
  cfg = config.j3ff.watchtower.pushgateway;
in
{
  options = {
    j3ff.watchtower.pushgateway = {
      enable = lib.mkEnableOption "Prometheus push gateway server";

      domain = lib.mkOption {
        type = lib.types.str;
        default = "pushgateway.j3ff.io";
        description = "DNS name of push gateway server.";
      };

      port = lib.mkOption {
        description = "Port the server listens on.";
        type = lib.types.port;
        default = 9091;
      };
    };
  };

  config = lib.mkIf cfg.enable {

    services.prometheus.pushgateway = {
      enable = true;
      web.external-url = "http://${cfg.domain}";
      web.listen-address = ":${toString cfg.port}";
    };

    services.nginx.virtualHosts."${cfg.domain}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.port}";
      };
    };
  };
}
