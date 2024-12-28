{ config, pkgs, ... }:
let
  backupDir = "/var/backup/gitea";
in
{
  age.secrets.smtp_passwd = {
    file = ../../secrets/smtp_passwd.age;
    owner = "gitea";
  };

  services.gitea = {
    enable = true;
    database.type = "postgres";
    settings = {
      log.LEVEL = "Warn";
      server = {
        ROOT_URL = "https://gitea.j3ff.io/";
        DOMAIN = "j3ff.io";
      };
      repository = {
        DEFAULT_BRANCH = "main";
      };
      mailer = {
        ENABLED = true;
        PROTOCOL = "smtps";
        FROM = "gitea@j3ff.io";
        SMTP_ADDR = "smtp.fastmail.com";
        SMTP_PORT = 465;
        USER = "jeff@j3ff.io";
      };
      indexer = {
        REPO_INDEXER_ENABLED = true;
        REPO_INDEXER_PATH = "indexers/repos.bleve";
        MAX_FILE_SIZE = 1048576;
      };
    };

    mailerPasswordFile = config.age.secrets.smtp_passwd.path;

    dump = {
      enable = true;
      inherit backupDir;
    };
  };

  services.nginx.virtualHosts."gitea.j3ff.io" = {
    # security.acme is configured for eris globally in nginx.nix
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;

    locations = {
      "/" = {
        proxyPass = "http://127.0.0.1:3000";
      };
    };
  };

  systemd.services.gitea-dump-prune = {
    enable = true;
    startAt = "daily";

    script = ''
      ${pkgs.findutils}/bin/find ${backupDir} -type f -mtime +5 -exec rm {} \;
    '';
  };

}
