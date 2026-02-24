# common/modules/watchtower/prometheus.nix
{ config, lib, ... }:
let
  cfg = config.j3ff.watchtower.prometheus;
  debNodePort = "9100";
  pbsExporterPort = "10019";
  blockyPort = 9101;
in
{
  options = {
    j3ff.watchtower.prometheus = {
      enable = lib.mkEnableOption "Prometheus monitoring server";

      domain = lib.mkOption {
        type = lib.types.str;
        default = "prometheus.j3ff.io";
        description = "DNS name of prometheus server.";
      };
    };
  };

  config = lib.mkIf cfg.enable {

    networking.hosts = {
      "10.1.0.2" = [ "pihole" ];
      "100.64.244.48" = [ "phobos" ];
      "10.1.0.12" = [ "pbs-1" ];
      "100.114.102.106" = [ "pbs-2" ];
      "10.1.0.9" = [ "pve-1" ];
      "10.1.0.11" = [ "pve-2" ];
      "10.1.0.49" = [ "styx" ];
      "10.1.0.50" = [ "pluto" ];
    };

    services.prometheus = {
      enable = true;
      port = 9001;
      retentionTime = "45d";
      webExternalUrl = "http://${cfg.domain}";

      globalConfig = {
        evaluation_interval = "1m";
        scrape_interval = "30s";
      };

      scrapeConfigs =
        let
          nodePort = toString config.services.prometheus.exporters.node.port;
          relabel_configs = [
            {
              source_labels = [ "__address__" ];
              target_label = "instance";
              replacement = "\${1}";
              regex = "([^:]+):([0-9]+)";
            }
          ];
        in
        [
          {
            job_name = "blocky";
            static_configs = [
              {
                targets = [ "pluto:${toString blockyPort}" ];
                labels = {
                  datacenter = "cloyster";
                };
              }
            ];
            inherit relabel_configs;
          }
          {
            job_name = "node";
            static_configs = [
              {
                targets = [
                  "eris:${nodePort}"
                  "ceres:${nodePort}"
                  "luna:${nodePort}"
                  "pbs-1:${debNodePort}"
                  "pluto:${nodePort}"
                  "pve-1:${debNodePort}"
                  "pve-2:${debNodePort}"
                  "vesta:${nodePort}"
                ];
                labels = {
                  datacenter = "cloyster";
                };
              }
              {
                targets = [
                  "pbs-2:${debNodePort}"
                  "phobos:${nodePort}"
                ];
                labels = {
                  datacenter = "gembrit";
                };
              }
            ];
            inherit relabel_configs;
          }
          {
            job_name = "grafana";
            static_configs = [
              {
                targets = [
                  "localhost:${toString config.services.grafana.settings.server.http_port}"
                ];
                labels = {
                  datacenter = "cloyster";
                };
              }
            ];
            relabel_configs = [
              {
                target_label = "instance";
                replacement = "vesta";
              }
            ];
          }
          {
            job_name = "pbs";
            static_configs = [
              {
                targets = [
                  "pbs-1:${pbsExporterPort}"
                ];
                labels = {
                  datacenter = "cloyster";
                };
              }
              {
                targets = [
                  "pbs-2:${pbsExporterPort}"
                ];
                labels = {
                  datacenter = "gembrit";
                };
              }
            ];
            inherit relabel_configs;
          }
          {
            job_name = "prometheus";
            static_configs = [
              {
                targets = [
                  "localhost:${toString config.services.prometheus.port}"
                ];
                labels = {
                  datacenter = "cloyster";
                };
              }
            ];
            relabel_configs = [
              {
                target_label = "instance";
                replacement = "vesta";
              }
            ];
          }
          {
            job_name = "smartctl";
            scrape_interval = "1m";
            static_configs = [
              {
                targets = [
                  "luna:${toString config.services.prometheus.exporters.smartctl.port}"
                ];
                labels = {
                  datacenter = "cloyster";
                };
              }
              {
                targets = [
                  "phobos:${toString config.services.prometheus.exporters.smartctl.port}"
                ];
                labels = {
                  datacenter = "gembrit";
                };
              }
            ];
            inherit relabel_configs;
          }
          {
            job_name = "ups";
            metrics_path = "/ups_metrics";
            params = {
              ups = [ "ups" ];
            };
            static_configs = [
              {
                targets = [
                  "localhost:9199"
                ];
                labels = {
                  datacenter = "cloyster";
                };
              }
            ];
            relabel_configs = [
              {
                target_label = "instance";
                replacement = "pve-1";
              }
            ];
          }
          {
            job_name = "unifi";
            scrape_interval = "2m";
            static_configs = [
              {
                targets = [
                  "localhost:${toString config.services.prometheus.exporters.unpoller.port}"
                ];
                labels = {
                  datacenter = "cloyster";
                };
              }
            ];
            relabel_configs = [
              {
                target_label = "instance";
                replacement = "cloyster";
              }
            ];
          }
          {
            job_name = "zrepl";
            static_configs = [
              {
                targets = [
                  "luna:9811"
                ];
                labels = {
                  datacenter = "cloyster";
                };
              }
              {
                targets = [
                  "phobos:9811"
                ];
                labels = {
                  datacenter = "gembrit";
                };
              }
            ];
            inherit relabel_configs;
          }
        ]
        ++ lib.optional config.j3ff.watchtower.exporters.pihole.enable {
          job_name = "pihole";
          static_configs = [
            {
              targets = [
                "localhost:${toString config.services.prometheus.exporters.pihole.port}"
              ];
              labels = {
                datacenter = "cloyster";
              };
            }
          ];
          relabel_configs = [
            {
              target_label = "instance";
              replacement = "pihole";
            }
          ];
        };

      alertmanagers = [
        {
          static_configs = [
            {
              targets = [ "localhost:${toString config.services.prometheus.alertmanager.port}" ];
            }
          ];
        }
      ];

      ruleFiles = [
        ./gitea-rules.yml
        ./node-rules.yml
        ./pbs-rules.yml
        ./smartctl-rules.yml
        ./unifi-rules.yml
        ./ups-rules.yml
      ]
      ++ lib.optional config.j3ff.watchtower.exporters.pihole.enable ./pihole-rules;

    };

    services.grafana.provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          access = "proxy";
          isDefault = true;
          url = "http://127.0.0.1:${toString config.services.prometheus.port}";
        }
      ];
    };

    services.caddy.virtualHosts."${cfg.domain}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString config.services.prometheus.port}
    '';
  };
}
