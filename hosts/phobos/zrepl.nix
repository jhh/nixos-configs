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
            "192.168.1.7" = "luna";
          };
        };
        root_fs = "rpool/zrepl";
      }];
    };
  };
}
