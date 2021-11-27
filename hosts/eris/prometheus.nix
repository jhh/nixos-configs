{ config, pkgs, ... }: {

  networking.hosts = {
    "100.64.244.48" = [ "phobos" ];
  };

  services.prometheus = {
    enable = true;
    port = 9001;

    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [{
          targets = [
            "eris:9002"
            "ceres:9002"
            "luna:9002"
            "phobos:9002"
            "pve-01:9100"
            "pve-02:9100"
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
        job_name = "prometheus";
        static_configs = [{
          targets = [
            "eris:9001"
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
