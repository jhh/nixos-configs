{ config, pkgs, ... }:
{
  age.secrets.rclone_conf = {
    file = ../../common/modules/secrets/rclone.conf.age;
  };

  systemd.services.b2-rclone = {
    startAt = "*-*-* 03:20:00";

    environment = {
      # RSYNC_RSH = "${pkgs.openssh}/bin/ssh";
    };

    script = ''
      echo backing up /mnt/tank/backup/git
      ${pkgs.rclone}/bin/rclone --config ${config.age.secrets.rclone_conf.path} sync /mnt/tank/backup/git b2:j3ff-git
    '';
  };

}

