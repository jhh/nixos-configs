{ config, pkgs, lib, ... }:

{
  services.zrepl = {
    enable = false;
    settings = {
      global = {
        logging = [{
          type = "syslog";
          level = "info";
          format = "human";
        }];
      };

      jobs = [{
        name = "backups";
        type = "push";
        connect = {
          type = "tcp";
          address = "192.168.1.10:29491";
        };
        filesystems = {
          "rpool/safe<" = true;
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
              type = "last_n";
              count = 10;
            }
          ];
          keep_receiver = [{
            type = "grid";
            regex = "^zrepl_";
            grid =
              lib.concatStringsSep " | " [ "1x1h(keep=all)" "24x1h" "365x1d" ];
          }];
        };
      }];
    };
  };
}
