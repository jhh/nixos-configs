{ config, pkgs, ... }:
let
  pushgatewayPort = 9091;
in
{

  networking.hosts = {
    "100.64.244.48" = [ "phobos" ];
    "100.88.59.15" = [ "pve-11" ];
    "100.124.210.30" = [ "docker-02" ];
  };

  age.secrets.pushover_token.file = ../../common/modules/secrets/pushover_token.age;

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

    virtualHosts."prometheus.j3ff.io" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.prometheus.port}";
      };
    };
    virtualHosts."alertmanager.j3ff.io" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.prometheus.alertmanager.port}";
      };
    };
    virtualHosts."pushgateway.j3ff.io" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString pushgatewayPort}";
      };
    };
  };

  services.prometheus = {
    enable = true;
    port = 9001;
    retentionTime = "15d";
    webExternalUrl = "http://prometheus.j3ff.io";

    scrapeConfigs =
      let
        nodePort = toString config.services.prometheus.exporters.node.port;
      in
      [
        {
          job_name = "node";
          static_configs = [{
            targets = [
              "docker-01:9100"
              "docker-02:9100"
              "eris:${nodePort}"
              "luna:${nodePort}"
              "phobos:${nodePort}"
              "pihole-01:9100"
              "pve-01:9100"
              "pve-02:9100"
              "pve-03:9100"
              "pve-11:9100"
              "unifi-01:9100"
              "ups-01:9100"
              "vesta:${nodePort}"
            ];
          }];
        }
        {
          job_name = "grafana";
          static_configs = [{
            targets = [
              "localhost:${toString config.services.grafana.port}"
            ];
          }];
        }
        {
          job_name = "prometheus";
          static_configs = [{
            targets = [
              "localhost:${toString config.services.prometheus.port}"
            ];
          }];
        }
        {
          job_name = "pihole";
          static_configs = [
            {
              targets = [
                "docker-01:9617"
              ];
            }
          ];
        }
        {
          job_name = "push";
          honor_labels = true;
          static_configs = [{
            targets = [ "localhost:${toString pushgatewayPort}" ];
          }];
        }
        {
          job_name = "ups";
          metrics_path = "/ups_metrics";
          params = { ups = [ "ups" ]; };
          static_configs = [
            {
              targets = [
                "docker-01:9199"
              ];
            }
          ];
        }
        {
          job_name = "unifi";
          scrape_interval = "30s";
          static_configs = [
            {
              targets = [
                "docker-01:9130"
              ];
            }
          ];
        }
        {
          job_name = "zrepl";
          static_configs = [
            {
              targets = [
                "luna:9811"
                "phobos:9811"
              ];
            }
          ];
        }
      ];

    alertmanagers = [{
      static_configs = [{
        targets = [ "localhost:${toString config.services.prometheus.alertmanager.port}" ];
      }];
    }];

    rules = [
      ''
        groups:
        - name: default
          rules:
          - alert: InstanceDown
            expr: up == 0
            for: 1m
            labels:
              severity: page
          - alert: ServiceFail
            expr: node_systemd_units{state="failed"} > 0
            labels:
              severity: page
          - alert: UpsStatus
            expr: network_ups_tools_ups_status{flag!="OL"} == 1
          - alert: PiholeStatus
            expr: pihole_status == 0
            labels:
              severity: page
          - alert: PbsBackupFail
            expr: time() - pbs_backup_completion_timestamp_seconds > 25*3600
          - alert: PostgresqlBackupFail
            expr: postgresql_backup_status == 0
      ''
    ];

    alertmanager = {
      enable = true;
      webExternalUrl = "http://alertmanager.j3ff.io";
      environmentFile = config.age.secrets.pushover_token.path;
      configuration = {
        global = {
          smtp_smarthost = "localhost:25";
          smtp_from = "alertmanager@j3ff.io";
        };
        route = {
          receiver = "email";
          repeat_interval = "4h";
          routes = [
            {
              receiver = "pushover";
              repeat_interval = "15m";
              matchers = [
                ''
                  severity="page"
                ''
              ];
            }
          ];
        };
        receivers = [
          {
            name = "email";
            email_configs = [{
              to = "jeff@j3ff.io";
              require_tls = false;
            }];
          }

          {
            name = "pushover";
            pushover_configs = [{
              user_key = "ugdx1vs5quycvqg3stin54ps5jqm3i";
              token = "$PUSHOVER_TOKEN";
            }];
          }
        ];
      };
    };

    pushgateway = {
      enable = true;
      web.external-url = "http://pushgateway.j3ff.io";
      web.listen-address = ":${toString pushgatewayPort}";
    };
  };
}




