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
      echo backing up /home/jeff/code/jhh/nixos-configs
      ${pkgs.rclone}/bin/rclone --config ${config.age.secrets.rclone_conf.path} sync /home/jeff/code/jhh/nixos-configs b2:j3ff-nixos-configs --exclude .direnv/ --exclude .git/ --exclude result
    '';
  };

}

