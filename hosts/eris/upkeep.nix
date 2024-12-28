{
  config,
  lib,
  pkgs,
  ...
}:
{

  age.secrets.upkeep_secrets = {
    file = ../../secrets/upkeep_secrets.age;
  };

  services.upkeep = {
    enable = true;
    port = 8001;
    secrets = [ config.age.secrets.upkeep_secrets.path ];
  };

  services.postgresql = lib.mkIf config.services.upkeep.enable {
    ensureDatabases = [ "upkeep" ];
    ensureUsers = [
      {
        name = "upkeep";
        ensureDBOwnership = true;
      }
    ];
  };

  systemd.services.postgresql.postStart = lib.mkIf config.services.upkeep.enable ''
    $PSQL -d upkeep -tA << END_INPUT
      ALTER DATABASE upkeep SET client_encoding TO 'UTF8';
      ALTER DATABASE upkeep SET default_transaction_isolation TO 'read committed';
      ALTER DATABASE upkeep SET timezone TO 'UTC';
    END_INPUT
  '';

  services.nginx = lib.mkIf config.services.upkeep.enable {
    enable = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;

    virtualHosts."upkeep.j3ff.io" = {
      # security.acme is configured for eris globally in nginx.nix
      forceSSL = true;
      enableACME = true;
      acmeRoot = null;

      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.upkeep.port}";
        };
      };
    };
  };
}
