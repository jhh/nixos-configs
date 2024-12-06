{ config, lib, pkgs, ... }: {

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
  };

  services.postgresqlBackup = {
    enable = true;
    startAt = "*-*-* 01:13:00";
    databases = [ "gitea" "miniflux" "paperless" "puka" "upkeep" ];
    pgdumpOptions = "--clean";
  };

  age.secrets.rclone_conf = {
    file = ../../secrets/rclone.conf.age;
  };

  systemd.services.postgresqlBackup-backup = {
    startAt = "*-*-* 02:13:00";

    script = ''
      RCLONE_OPTS="--config ${config.age.secrets.rclone_conf.path} -v"

      src=/var/backup/postgresql
      echo backing up $src
      ${pkgs.rclone}/bin/rclone $RCLONE_OPTS sync $src luna:/mnt/tank/backup/postgres/eris
    '';
  };

  age.secrets.pgadmin_passwd = lib.mkIf config.services.pgadmin.enable {
    file = ../../secrets/pgadmin_passwd.age;
    owner = "pgadmin";
    group = "pgadmin";
  };

  services.pgadmin = {
    enable = true;
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
