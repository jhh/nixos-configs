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
      };
      jobs = [{
        name = "sink";
        type = "sink";
        serve = {
          type = "tcp";
          listen = ":29491";
          clients = {
            "100.93.77.66" = "eris";
          };
        };
        root_fs = "rpool/zrepl";
      }];
    };
  };
}
