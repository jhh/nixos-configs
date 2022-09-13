# common/modules/watchtower/prometheus.nix
{ config, lib, pkgs, ... }:
let
  cfg = config.j3ff.watchtower.prometheus;
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
      "100.64.244.48" = [ "phobos" ];
      "100.88.59.15" = [ "pve-11" ];
      "100.124.210.30" = [ "docker-02" ];
    };

    services.prometheus = {
      enable = true;
      port = 9001;
      retentionTime = "15d";
      webExternalUrl = "http://${cfg.domain}";

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
                "pve-11:9100"
                # "ups-01:9100"
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
              targets = [ "localhost:${toString config.j3ff.watchtower.pushgateway.port}" ];
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
              expr: network_ups_tools_ups_status{flag!="OL"} == 1
            - alert: PiholeStatus
              expr: pihole_status == 0
              for: 1m
              labels:
                severity: page
        ''
        ''
          - name: backup.rules
            rules:
            - alert: PbsBackupFail
              expr: time() - pbs_backup_completion_timestamp_seconds > 25*3600
            - alert: PostgresqlBackupFail
              expr: postgresql_backup_status == 0
        ''
        ''
          - name: node.rules
            rules:
            - alert: ServiceFail
              expr: node_systemd_unit_state{state="failed"} > 0
              annotations:
                description: Instance {{ $labels.instance }} service {{ $labels.name }} is in failed state.
              labels:
                severity: page
            - alert: DiskWillFillIn1Day
              expr: predict_linear(node_filesystem_free_bytes{job="node",fstype="ext4"}[6h], 24 * 3600) < 0
              for: 5m
            - alert: DiskSpace
              expr: node_filesystem_avail_bytes{fstype="ext4"} / node_filesystem_size_bytes{fstype="ext4"} < 0.25
              for: 5m
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
      datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          access = "proxy";
          isDefault = true;
          url = "http://127.0.0.1:${toString config.services.prometheus.port}";
        }
      ];
    };

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts."${cfg.domain}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.prometheus.port}";
        };
      };
    };
  };
}
