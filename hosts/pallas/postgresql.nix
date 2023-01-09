{ config, pkgs, ... }:
let
  backupDir = "/mnt/backup/postgres";
in
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
  };

}
