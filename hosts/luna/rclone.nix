{ config, pkgs, ... }:
{
  age.secrets.rclone_conf = {
    file = ../../common/modules/secrets/rclone.conf.age;
  };

  systemd.services.b2-rclone = {
    startAt = "*-*-* 03:20:00";

    script = ''
      RCLONE_OPTS="--config ${config.age.secrets.rclone_conf.path} --skip-links --fast-list --transfers=32"

      echo backing up /mnt/tank/backup/git
      ${pkgs.rclone}/bin/rclone $RCLONE_OPTS sync /mnt/tank/backup/git b2:j3ff-git

      echo backing up /mnt/tank/share/jeff
      ${pkgs.rclone}/bin/rclone $RCLONE_OPTS sync /mnt/tank/share/jeff b2:j3ff-home/jeff/

      echo backing up /mnt/tank/media/plex/music
      ${pkgs.rclone}/bin/rclone $RCLONE_OPTS sync /mnt/tank/media/plex/music b2:j3ff-music/iTunes/Music
    '';
  };

}

