{ config, pkgs, ... }: {

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
  };

  services.postgresqlBackup = {
    enable = true;
    databases = [ "gitea" "miniflux" "puka" ];
    pgdumpOptions = "--clean";
  };

}
