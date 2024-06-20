{ config, pkgs, ... }:
{
  age.secrets.rclone_conf = {
    file = ../../secrets/rclone.conf.age;
  };

  systemd.services.b2-rclone = {
    startAt = "*-*-* 03:20:00";

    script = ''
      RCLONE_OPTS="--config ${config.age.secrets.rclone_conf.path} --skip-links --fast-list --transfers=32 -v"

      echo backing up /mnt/tank/backup/git
      ${pkgs.rclone}/bin/rclone $RCLONE_OPTS sync /mnt/tank/backup/git b2:j3ff-git

      echo backing up /mnt/tank/share/jeff
      ${pkgs.rclone}/bin/rclone $RCLONE_OPTS sync /mnt/tank/share/jeff b2:j3ff-home/jeff/

      echo backing up /mnt/tank/media/plex/music
      ${pkgs.rclone}/bin/rclone $RCLONE_OPTS sync /mnt/tank/media/plex/music/Music b2:j3ff-music/iTunes/Music/

      echo backing up /mnt/tank/media/lightroom
      ${pkgs.rclone}/bin/rclone $RCLONE_OPTS sync /mnt/tank/media/lightroom b2:j3ff-photos/Lightroom/

      echo backing up /mnt/tank/share/homelab
      ${pkgs.rclone}/bin/rclone $RCLONE_OPTS sync /mnt/tank/share/homelab b2:j3ff-homelab/Io/

      echo backing up /mnt/tank/media/paperless
      ${pkgs.rclone}/bin/rclone $RCLONE_OPTS sync /mnt/tank/media/paperless b2:j3ff-paperless
    '';
  };

}

