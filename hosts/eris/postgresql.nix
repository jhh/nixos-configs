{ config, pkgs, ... }: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
    enableTCPIP = true;

    ensureDatabases = [ "jeff" "puka" ];

    ensureUsers = [
      {
        name = "jeff";
        ensurePermissions = {
          "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
        };
      }
      {
        name = "puka";
        ensurePermissions = {
          "DATABASE puka" = "ALL PRIVILEGES";
        };
      }
    ];

    authentication = ''
      host all all 192.168.1.0/24 md5
    '';
    # psql, \password
    # ALTER USER jeff CREATEDB
  };

  ##########
  # backups
  ##########
  fileSystems."/mnt/backup" = {
    device = "luna.lan.j3ff.io:/mnt/tank/backup/postgres";
    fsType = "nfs";
  };


  systemd.services.postgres-backup = {

    startAt = "daily";

    environment = {
      BACKUP_USER = "postgres";
      BACKUP_DIR = "/mnt/backup/eris/";
      ENABLE_CUSTOM_BACKUPS = "yes";
      ENABLE_PLAIN_BACKUPS = "yes";
      ENABLE_GLOBALS_BACKUPS = "yes";
      DAY_OF_WEEK_TO_KEEP = "5";
      DAYS_TO_KEEP = "7";
      WEEKS_TO_KEEP = "4";

    };

    serviceConfig = {
      User = "postgres";
    };

    path = [ pkgs.postgresql_14 pkgs.gzip ];

    script = builtins.readFile ./postgres-backup.sh;
  };
}
