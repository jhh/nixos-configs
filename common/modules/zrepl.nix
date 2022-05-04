{ config, pkgs, lib, ... }:
let
  cfg = config.j3ff.zrepl;

  grid =
    lib.concatStringsSep " | " [ "1x1h(keep=all)" "24x1h" "30x1d" "6x1w" ];

  backups = {
    name = "backups";
    type = "push";
    connect = {
      type = "tcp";
      address = "${config.j3ff.zrepl.server}:29491";
    };
    send.compressed = true;
    snapshotting = {
      type = "periodic";
      prefix = "zrepl_";
      interval = "30m";
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
  };

in
{
  options = {
    j3ff.zrepl = {
      enable = lib.mkEnableOption "ZFS replication";

      filesystems = lib.mkOption {
        type = with lib.types; attrsOf bool;
        description = "filesystems to back up as part of default job";
        default = {
          "rpool/safe<" = true;
          "rpool/safe/root" = false;
        };
      };

      extraJobs = lib.mkOption {
        type = with lib.types; listOf anything;
        description = "extra zrepl jobs to schedule";
        default = [ ];
      };

      server = lib.mkOption {
        type = lib.types.str;
        description = "zrepl sink to backup to.";
        default = "100.64.244.48";
      };
    };
  };

  config = lib.mkIf cfg.enable {
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

        jobs = [ (backups // { filesystems = cfg.filesystems; }) ] ++ cfg.extraJobs;
      };
    };
  };
}
