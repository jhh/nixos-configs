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
      jobs = [
        {
          name = "backups";
          type = "push";
          connect = {
            type = "tcp";
            address = "${config.j3ff.zrepl.server}:29491";
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
        }
      ];
    };
  };
}
