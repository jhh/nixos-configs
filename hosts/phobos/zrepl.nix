{ config, pkgs, lib, ... }:
{
  j3ff.zrepl = {
    enable = true;
    server = "100.78.167.19";
    filesystems = {
      "rpool/safe<" = true;
      "rpool/safe/root" = false;
      "rpool/tank/share<" = true;
    };
  };
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
            "100.121.169.6" = "ceres";
            "100.93.77.66" = "eris";
            "100.78.167.19" = "luna";
          };
        };
        root_fs = "rpool/zrepl";
      }];
    };
  };
}
