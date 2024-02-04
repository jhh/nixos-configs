{ config, pkgs, ... }:
{
  age.secrets.rclone_conf = {
    file = ../../secrets/rclone.conf.age;
  };

  systemd.services.b2-rclone = {
    startAt = "*-*-* 03:20:00";

    script = ''
      RCLONE_OPTS="--config ${config.age.secrets.rclone_conf.path} --skip-links --fast-list --transfers=32 -v"

      echo backing up /mnt/tank/share/strykeforce
      ${pkgs.rclone}/bin/rclone $RCLONE_OPTS sync /mnt/tank/share/strykeforce b2:j3ff-strykeforce
    '';
  };

}
