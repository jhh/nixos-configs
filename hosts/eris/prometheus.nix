{ config, pkgs, ... }: {
  services.prometheus = {
    enable = true;
    port = 9001;

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" "processes" ];
        port = 9002;
      };
    };

    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [{
          targets = [
            "eris:${toString config.services.prometheus.exporters.node.port}"
            "ceres:9002"
            "luna:9002"
            "phobos:9002"
          ];
        }];
      }
      {
        job_name = "grafana";
        static_configs = [{
          targets = [
            "eris:80"
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
        job_name = "zrepl";
        static_configs = [
          {
            targets = [
              "ceres:9811"
              "eris:9811"
              "luna:9811"
              "phobos:9811"
            ];
          }
        ];
      }
    ];
  };
}
