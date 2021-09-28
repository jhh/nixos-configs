{ config, pkgs, lib, ... }:
{
  services.zrepl = {
    enable = true;
    settings = {
      global = {
        logging = [{
          type = "syslog";
          level = "info";
          format = "human";
        }];
        monitoring = [{
          type = "prometheus";
          listen = ":9811";
        }];
      };
      jobs = [{
        name = "sink";
        type = "sink";
        serve = {
          type = "tcp";
          listen = ":29491";
          clients = {
            "100.103.156.2" = "ceres";
            "100.93.77.66" = "eris";
            "100.78.167.19" = "luna";
          };
        };
        root_fs = "rpool/zrepl";
      }];
    };
  };
}
