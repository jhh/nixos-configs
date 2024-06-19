{ config, pkgs, ... }:
let
  # 1. create and NFS-export media dir from luna
  # 2. mount media dir on pve-1 in /mnt/bindmounts
  # 3. create bindmount in proxmox admin console
  # 4. configure and start paperless
  mediaDir = "/mnt/paperless/media";
  dbName = "paperless";
in
{
  age.secrets.paperless_passwd = {
    file = ../../secrets/paperless_passwd.age;
  };

  users.users.${config.services.paperless.user}.extraGroups = [ "media" ];

  services.paperless = {
    enable = true;
    inherit mediaDir;
    consumptionDirIsPublic = true;
    passwordFile = config.age.secrets.paperless_passwd.path;
    settings = {
      PAPERLESS_DBHOST = "/run/postgresql";
      PAPERLESS_DATE_ORDER = "MDY";
    };
  };

  services.postgresql = {
    ensureDatabases = [ dbName ];
    ensureUsers = [
      {
        name = dbName;
        ensureDBOwnership = true;
      }
    ];
  };

  systemd.services.postgresql.postStart = ''
    $PSQL -d ${dbName} -tA << END_INPUT
      ALTER ROLE ${dbName} SET client_encoding TO 'utf8';
      ALTER ROLE ${dbName} SET default_transaction_isolation TO 'read committed';
      ALTER ROLE ${dbName} SET timezone TO 'UTC';
    END_INPUT
  '';

  services.nginx.virtualHosts."paperless.j3ff.io" = {
    # security.acme is configured for eris globally in nginx.nix
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;

    locations = {
      "/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.paperless.port}";
      };
    };
  };
}
