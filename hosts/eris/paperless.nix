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

  services.caddy.virtualHosts."paperless.j3ff.io".extraConfig = ''
    reverse_proxy http://127.0.0.1:${toString config.services.paperless.port}
  '';

  services.vsftpd = {
    enable = true;
    writeEnable = true;
    localUsers = true;
    userlist = [ "paperless" ];
    chrootlocalUser = true;
    allowWriteableChroot = true;
  };

}
