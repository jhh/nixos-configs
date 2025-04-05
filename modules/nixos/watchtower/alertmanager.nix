# common/modules/watchtower/alertmanager.nix
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.j3ff.watchtower.alertmanager;
in
{
  options = {
    j3ff.watchtower.alertmanager = {
      enable = lib.mkEnableOption "Prometheus alert manager server";

      domain = lib.mkOption {
        type = lib.types.str;
        default = "alertmanager.j3ff.io";
        description = "DNS name of alert manager server.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.pushover_token.file = ../../../secrets/pushover_token.age;

    services.prometheus.alertmanager = {
      enable = true;
      webExternalUrl = "http://${cfg.domain}";
      environmentFile = config.age.secrets.pushover_token.path;
      configuration = {
        global = {
          smtp_smarthost = "localhost:25";
          smtp_from = "alertmanager@j3ff.io";
        };
        route = {
          receiver = "email";
          repeat_interval = "12h";
          routes = [
            {
              receiver = "pushover";
              repeat_interval = "4h";
              matchers = [ ''severity="page"'' ];
            }
          ];
        };
        receivers = [
          {
            name = "email";
            email_configs = [
              {
                to = "jeff@j3ff.io";
                require_tls = false;
              }
            ];
          }

          {
            name = "pushover";
            pushover_configs = [
              {
                user_key = "ugdx1vs5quycvqg3stin54ps5jqm3i";
                token = "$PUSHOVER_TOKEN";
                retry = "1h";
                expire = "4h";
              }
            ];
          }
        ];
      };
    };

    services.nginx.virtualHosts."${cfg.domain}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.prometheus.alertmanager.port}";
      };
    };
  };
}
