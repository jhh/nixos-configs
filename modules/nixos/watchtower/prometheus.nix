# common/modules/watchtower/prometheus.nix
{ config, lib, ... }:
let
  cfg = config.j3ff.watchtower.prometheus;
  debNodePort = "9100";
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
    };

    services.prometheus = {
      enable = true;
      port = 9001;
      retentionTime = "15d";
      webExternalUrl = "http://${cfg.domain}";

      globalConfig = {
        evaluation_interval = "1m";
        scrape_interval = "30s";
      };

      scrapeConfigs =
        let
          nodePort = toString config.services.prometheus.exporters.node.port;
        in
        [
          {
            job_name = "node";
            static_configs = [
              {
                targets = [
                  "eris:${nodePort}"
                  "ceres:${nodePort}"
                  "luna:${nodePort}"
                  "pbs-1:${debNodePort}"
                  "pihole:${debNodePort}"
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
          }
          {
            job_name = "grafana";
            static_configs = [
              {
                targets = [
                  "localhost:${toString config.services.grafana.settings.server.http_port}"
                ];
              }
            ];
          }
          {
            job_name = "prometheus";
            static_configs = [
              {
                targets = [
                  "localhost:${toString config.services.prometheus.port}"
                ];
              }
            ];
          }
          {
            job_name = "push";
            honor_labels = true;
            static_configs = [
              {
                targets = [ "localhost:${toString config.j3ff.watchtower.pushgateway.port}" ];
              }
            ];
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
        ]
        ++ lib.optional config.j3ff.watchtower.exporters.pihole.enable {
          job_name = "pihole";
          static_configs = [
            {
              targets = [
                "localhost:${toString config.services.prometheus.exporters.pihole.port}"
              ];
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

      rules = [
        ''
          groups:
        ''
        ''
          - name: default.rules
            rules:
            - alert: InstanceDown
              expr: up == 0
              for: 5m
              labels:
                severity: page
              annotations:
                description: '{{ $labels.instance }} has been down for more than 5 minutes.'
                summary: 'Instance {{ $labels.instance }} down'
            - alert: UpsStatus
              expr: changes(network_ups_tools_ups_status[5m]) > 0
            - alert: UpsOnBattery
              expr: network_ups_tools_ups_status{flag="OB"} == 1
              labels:
                severity: page
            - alert: PiholeStatus
              expr: pihole_status == 0
              for: 5m
              labels:
                severity: page
        ''
        ''
          - name: backup.rules
            rules:
            - alert: PbsBackupFail
              expr: time() - pbs_backup_completion_timestamp_seconds > 25*3600
              for: 1h
            - alert: PostgresqlBackupFail
              expr: postgresql_backup_status == 0
              for: 1h
        ''
        ''
          - name: node.rules
            rules:
            - alert: ServiceFail
              expr: node_systemd_unit_state{state="failed"} > 0
              for: 10m
              annotations:
                description: Instance {{ $labels.instance }} service {{ $labels.name }} is in failed state.
              labels:
                severity: page
            - alert: DiskWillFillIn1Day
              expr: predict_linear(node_filesystem_free_bytes{job="node",fstype="ext4"}[6h], 24 * 3600) < 0
              for: 10m
            - alert: DiskSpace
              expr: node_filesystem_avail_bytes{fstype="ext4"} / node_filesystem_size_bytes{fstype="ext4"} < 0.25
              for: 10m
              annotations:
                description: '{{ $labels.instance }} mountpoint "{{ $labels.mountpoint }}" is > 75% full.'
                summary: 'Instance {{ $labels.instance }} disk space'
        ''
        ''
          - name: unifi.rules
            rules:
            - alert: SpeedTestRunDate
              expr: time() - unifipoller_device_speedtest_rundate_seconds > 25 * 3600
              for: 15m
              annotations:
                description: Last Unifi speed test run was > 25 hours ago.
            - alert: SpeedTestDownload
              expr: unifipoller_device_speedtest_download < 850
              for: 15m
              annotations:
                description: Unifi speed test download < 850 Mb/s
            - alert: SpeedTestUpload
              expr: unifipoller_device_speedtest_upload < 850
              for: 15m
              annotations:
                description: Unifi speed test upload < 850 Mb/s
        ''
      ];

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

    services.nginx.virtualHosts."${cfg.domain}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.prometheus.port}";
      };
    };
  };
}
