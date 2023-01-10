{ config, pkgs, ... }:
let
  backupDir = "/mnt/backup/postgres";
in
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
    settings = {
      unix_socket_directories = "/run/postgresql";
    };
  };

  services.postgresqlBackup = {
    enable = true;
    databases = [ "strykeforce" ];
    pgdumpOptions = "--clean";
  };

}
