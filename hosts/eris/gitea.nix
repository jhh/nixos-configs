{ config, pkgs, ... }:
let
  backupDir = "/mnt/backup/gitea";
in
{
  age.secrets.smtp_passwd =
    {
      file = ../../common/modules/secrets/smtp_passwd.age;
      owner = "gitea";
    };

  ##########
  # backups
  ##########
  fileSystems."${backupDir}" = {
    device = "luna.lan.j3ff.io:/mnt/tank/backup/gitea";
    fsType = "nfs";
  };

  services.gitea = {
    enable = true;
    domain = "j3ff.io";
    rootUrl = "http://eris.ts.j3ff.io:3000/";
    database.type = "postgres";
    log.level = "Warn";
    settings = {
      mailer = {
        ENABLED = true;
        MAILER_TYPE = "smtp";
        FROM = "gitea@j3ff.io";
        HOST = "smtp.fastmail.com:465";
        IS_TLS_ENABLED = true;
        USER = "jeff@j3ff.io";
      };
    };
    mailerPasswordFile = config.age.secrets.smtp_passwd.path;
    dump = {
      enable = true;
      type = "tar.bz2";
      backupDir = "${backupDir}/eris";
    };
  };

}
