{ config, pkgs, lib, ... }:
let
  grid =
    lib.concatStringsSep " | " [ "1x1h(keep=all)" "24x1h" "30x1d" "6x1w" ];

  tm_grid =
    lib.concatStringsSep " | " [ "4x1h(keep=all)" "24x1h" "14x1d" ];

  interval = "15m";
in
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
            "rpool/safe/root" = false;
            "rpool/tank/media<" = true;
            "rpool/tank/share<" = true;
          };
          send.compressed = true;
          snapshotting = {
            type = "periodic";
            prefix = "zrepl_";
            inherit interval;
          };
          pruning = {
            keep_sender = [
              { type = "not_replicated"; }
              {
                type = "grid";
                regex = "^zrepl_";
                inherit grid;
              }
            ];
            keep_receiver = [{
              type = "grid";
              regex = "^zrepl_";
              inherit grid;
            }];
          };
        }
        {
          name = "time_machine";
          type = "snap";
          filesystems = {
            "rpool/tank/backup/tm<" = true;
          };
          snapshotting = {
            type = "periodic";
            prefix = "zrepl_";
            inherit interval;
          };
          pruning = {
            keep = [
              {
                type = "grid";
                regex = "^zrepl_";
                grid = tm_grid;
              }
            ];
          };
        }
      ];
    };
  };
}
