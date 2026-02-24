{
  config,
  lib,
  pkgs,
  ...
}:
{

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
  };

  services.postgresqlBackup = {
    enable = true;
    startAt = "*-*-* 01:13:00";
    databases = [
      "gitea"
      "miniflux"
      "paperless"
      "puka"
    ];
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
    enable = false;
    initialEmail = "jeff@j3ff.io";
    initialPasswordFile = "${config.age.secrets.pgadmin_passwd.path}";
  };

  environment.systemPackages = [
    (
      let
        # XXX specify the postgresql package you'd like to upgrade to.
        # Do not forget to list the extensions you need.
        newPostgres = pkgs.postgresql_17;
        cfg = config.services.postgresql;
      in
      pkgs.writeScriptBin "upgrade-pg-cluster" ''
        set -eux
        # XXX it's perhaps advisable to stop all services that depend on postgresql
        systemctl stop postgresql

        export NEWDATA="/var/lib/postgresql/${newPostgres.psqlSchema}"

        export NEWBIN="${newPostgres}/bin"

        export OLDDATA="${cfg.dataDir}"
        export OLDBIN="${cfg.package}/bin"

        install -d -m 0700 -o postgres -g postgres "$NEWDATA"
        cd "$NEWDATA"
        sudo -u postgres $NEWBIN/initdb -D "$NEWDATA" ${lib.escapeShellArgs cfg.initdbArgs}

        sudo -u postgres $NEWBIN/pg_upgrade \
          --old-datadir "$OLDDATA" --new-datadir "$NEWDATA" \
          --old-bindir $OLDBIN --new-bindir $NEWBIN \
          "$@"
      ''
    )
  ];
}
