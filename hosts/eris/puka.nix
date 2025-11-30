{
  config,
  lib,
  pkgs,
  ...
}:
{

  age.secrets.puka_secrets = {
    file = ../../secrets/puka_secrets.age;
  };

  services.puka = {
    enable = true;
    secrets = [ config.age.secrets.puka_secrets.path ];
  };

  services.postgresql = lib.mkIf config.services.puka.enable {
    ensureDatabases = [ "puka" ];
    ensureUsers = [
      {
        name = "puka";
        ensureDBOwnership = true;
      }
    ];
  };

  systemd.services.postgresql.postStart = lib.mkIf config.services.puka.enable ''
    ${config.services.postgresql.package}/bin/psql -d puka -tA << END_INPUT
      ALTER DATABASE puka SET client_encoding TO 'UTF8';
      ALTER DATABASE puka SET default_transaction_isolation TO 'read committed';
      ALTER DATABASE puka SET timezone TO 'UTC';
    END_INPUT
  '';

  services.nginx = lib.mkIf config.services.puka.enable {
    enable = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;

    virtualHosts."puka.j3ff.io" = {
      # security.acme is configured for eris globally in nginx.nix
      forceSSL = true;
      enableACME = true;
      acmeRoot = null;

      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.puka.port}";
        };
      };
    };
  };
}
