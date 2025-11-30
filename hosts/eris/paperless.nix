{ config, pkgs, ... }:
let
  # 1. create and NFS-export media dir from luna
  # 2. mount media dir on pve-1 in /mnt/bindmounts
  # 3. create bindmount in proxmox admin console
  # 4. configure and start paperless
  mediaDir = "/mnt/paperless/media";
  dbName = "paperless";

in
# paperless-ngx = pkgs.paperless-ngx.overridePythonAttrs (old: {
#   disabledTests = old.disabledTests ++ [ "test_rtl_language_detection" ];
# });
{
  age.secrets.paperless_admin_passwd = {
    file = ../../secrets/paperless_admin_passwd.age;
  };

  services.paperless = {
    enable = true;
    # package = paperless-ngx;
    inherit mediaDir;
    consumptionDirIsPublic = true;
    passwordFile = config.age.secrets.paperless_admin_passwd.path;
    settings = {
      PAPERLESS_DBHOST = "/run/postgresql";
      PAPERLESS_DATE_ORDER = "MDY";
      PAPERLESS_URL = "https://paperless.j3ff.io";
      PAPERLESS_PROXY_SSL_HEADER = ''["HTTP_X_FORWARDED_PROTO", "https"]'';
      PAPERLESS_ACCOUNT_SESSION_REMEMBER = true;
      PAPERLESS_OCR_SKIP_ARCHIVE_FILE = "with_text";
      PAPERLESS_CONSUMER_ENABLE_ASN_BARCODE = true;
    };
    exporter = {
      enable = true;
      directory = "/mnt/paperless/backup";
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
    ${config.services.postgresql.package}/bin/psql -d paperless -tA << END_INPUT
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

          # Minimal CORS
          add_header 'Access-Control-Allow-Origin' '*' always;

          # Handle preflight requests
          if ($request_method = 'OPTIONS') {
              add_header 'Access-Control-Allow-Origin' '*' always;
              add_header 'Access-Control-Allow-Methods' 'GET, OPTIONS' always;
              add_header 'Access-Control-Allow-Headers' 'Content-Type, Authorization' always;
              return 204;
          }
        '';
      };
    };
  };

  services.vsftpd = {
    enable = true;
    writeEnable = true;
    localUsers = true;
    userlist = [ "paperless" ];
    chrootlocalUser = true;
    allowWriteableChroot = true;
  };

}
