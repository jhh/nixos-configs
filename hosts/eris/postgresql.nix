{ config, pkgs, ... }:
let
  backupDir = "/mnt/backup/postgres";
  postgresqlPkg = pkgs.postgresql_16;
in
{
  services.postgresql = {
    enable = true;
    package = postgresqlPkg;
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
      USERNAME = "postgres";
      HOSTNAME = "localhost";

    };

    path = [ postgresqlPkg pkgs.gzip pkgs.curl ];

    serviceConfig = {
      User = "postgres";
      ExecStart = pkgs.writeShellScript "postgres-backup" (builtins.readFile ./postgres-backup.sh);
    };
  };
}
