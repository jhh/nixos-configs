{ config, pkgs, ... }:
let
  backupDir = "/mnt/backup/postgres";
in
{
  # connect as postgres user: sudo -u postgres -H -- psql -d postgres

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    settings = {
      unix_socket_directories = "/run/postgresql";
    };
  };

  services.postgresqlBackup = {
    enable = false;
    databases = [ "strykeforce" ];
    pgdumpOptions = "--clean";
  };

  age.secrets.pgadmin_passwd = pkgs.lib.mkIf config.services.pgadmin.enable {
    file = ../../secrets/pgadmin_passwd.age;
    owner = "pgadmin";
    group = "pgadmin";
  };

  services.pgadmin = {
    enable = false;
    initialEmail = "jeff@j3ff.io";
    initialPasswordFile = "${config.age.secrets.pgadmin_passwd.path}";
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;


    virtualHosts."pgadmin.j3ff.io" = pkgs.lib.mkIf config.services.pgadmin.enable {

      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:5050";
        };

      };
    };
  };

}
