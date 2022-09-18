{ config, pkgs, ... }:
{
  # services.rpcbind.enable = true;
  # systemd.mounts = [{
  #   type = "nfs";
  #   mountConfig = {
  #     Options = "noatime";
  #   };
  #   what = "10.1.0.7:/mnt/tank/services/gitea";
  #   where = "/var/lib/gitea";
  #   before = [ "systemd-tmpfiles-setup.service" ];
  # }];

  age.secrets.smtp_passwd =
    {
      file = ../../common/modules/secrets/smtp_passwd.age;
      owner = "gitea";
    };


  services.gitea = {
    enable = true;
    domain = "j3ff.io";
    rootUrl = "http://eris.ts.j3ff.io:3000/";
    database.type = "postgres";
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
  };
}
