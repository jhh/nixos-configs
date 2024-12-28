{
  config,
  lib,
  pkgs,
  ...
}:
{

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
  };

  age.secrets.pgadmin_passwd = lib.mkIf config.services.pgadmin.enable {
    file = ../../secrets/pgadmin_passwd.age;
    owner = "pgadmin";
    group = "pgadmin";
  };

  services.pgadmin = {
    enable = false;
    initialEmail = "jeff@j3ff.io";
    initialPasswordFile = "${config.age.secrets.pgadmin_passwd.path}";
  };

  # enabled in todo.nix
  services.nginx.virtualHosts."pgadmin.j3ff.io" = lib.mkIf config.services.pgadmin.enable {
    locations = {
      "/" = {
        proxyPass = "http://127.0.0.1:5050";
      };
    };
  };

}
