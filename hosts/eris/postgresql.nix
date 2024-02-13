{ config, pkgs, ... }:
let
  backupDir = "/mnt/backup/postgres";
in
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    enableTCPIP = true;

    # ensureDatabases = [ "jeff" ];

    # ensureUsers = [
    #   {
    #     name = "jeff";
    #     # ensureDBOwnership = true;
    #   }
    # ];

    authentication = ''
      host all all 10.1.0.0/24 md5
    '';
    # psql, \password
    # ALTER USER jeff CREATEDB
  };

  ##########
  # backups
  ##########
  # fileSystems."${backupDir}" = {
  #   device = "luna.lan.j3ff.io:/mnt/tank/backup/postgres";
  #   fsType = "nfs";
  # };


  systemd.services.postgres-backup = {

    enable = false;

    startAt = "daily";

    environment = {
      BACKUP_USER = "postgres";
      BACKUP_DIR = "${backupDir}/eris/";
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

    path = [ pkgs.postgresql_16 pkgs.gzip pkgs.curl ];

    script = builtins.readFile ./postgres-backup.sh;
  };
}
