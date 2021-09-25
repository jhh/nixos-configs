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
            "100.103.156.2" = "ceres";
            "100.93.77.66" = "eris";
          };
        };
        root_fs = "rpool/zrepl";
      }

        {
          name = "backups";
          type = "push";
          connect = {
            type = "tcp";
            address = "192.168.1.5:29491";
          };
          filesystems = {
            "rpool/safe<" = true;
            "rpool/tank/media<" = true;
            "rpool/tank/share<" = true;
          };
          send.compressed = true;
          snapshotting = {
            type = "periodic";
            prefix = "zrepl_";
            interval = "10m";
          };
          pruning = {
            keep_sender = [
              { type = "not_replicated"; }
              {
                type = "regex";
                negate = true;
                regex = "^zrepl_";
              }
            ];
            keep_receiver = [{
              type = "grid";
              regex = "^zrepl_";
              grid =
                lib.concatStringsSep " | " [ "1x1h(keep=all)" "24x1h" "6x30d" ];
            }];
          };
        }];
    };
  };
}
