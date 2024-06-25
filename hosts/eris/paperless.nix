{ config, pkgs, ... }:
let
  # 1. create and NFS-export media dir from luna
  # 2. mount media dir on pve-1 in /mnt/bindmounts
  # 3. create bindmount in proxmox admin console
  # 4. configure and start paperless
  mediaDir = "/mnt/paperless/media";
  backupDir = "/mnt/paperless/backup";
  dbName = "paperless";

  paperless-ngx = pkgs.paperless-ngx.overridePythonAttrs (old: {
    disabledTests = old.disabledTests ++ [ "test_rtl_language_detection" ];
  });
in
{
  age.secrets.paperless_passwd = {
    file = ../../secrets/paperless_passwd.age;
  };

  users.users.${config.services.paperless.user}.extraGroups = [ "media" ];

  services.paperless = {
    enable = true;
    package = paperless-ngx;
    inherit mediaDir;
    consumptionDirIsPublic = true;
    passwordFile = config.age.secrets.paperless_passwd.path;
    settings = {
      PAPERLESS_DBHOST = "/run/postgresql";
      PAPERLESS_DATE_ORDER = "MDY";
      PAPERLESS_URL = "https://paperless.j3ff.io";
      PAPERLESS_PROXY_SSL_HEADER = ''["HTTP_X_FORWARDED_PROTO", "https"]'';
      PAPERLESS_ACCOUNT_SESSION_REMEMBER = true;
      PAPERLESS_OCR_SKIP_ARCHIVE_FILE = "with_text";
      PAPERLESS_CONSUMER_ENABLE_ASN_BARCODE = true;
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
        recommendedProxySettings = true;
        # https://github.com/paperless-ngx/paperless-ngx/wiki/Using-a-Reverse-Proxy-with-Paperless-ngx#nginx
        proxyWebsockets = true;
        extraConfig = ''
          proxy_redirect off;
          add_header Referrer-Policy "strict-origin-when-cross-origin";
        '';
      };
    };
  };

  systemd.services."paperless-dump" = {
    startAt = "*-*-* 00/4:13:00"; # every 4 hours at 13 min past

    script = ''
      set -eu
      ${config.services.paperless.dataDir}/paperless-manage document_exporter --no-progress-bar ${backupDir}
    '';

    serviceConfig = {
      User = config.services.paperless.user;
    };
  };
}
