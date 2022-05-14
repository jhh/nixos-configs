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
}
