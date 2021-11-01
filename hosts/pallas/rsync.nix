{ config, pkgs, ... }:
{
  systemd.services.jeff-backup = {

    startAt = "hourly";

    environment = {
      RSYNC_RSH = "${pkgs.openssh}/bin/ssh";
    };

    script = ''
      echo backing up /home/jeff
      ${pkgs.rsync}/bin/rsync -az /home/jeff sshd@luna:backup/pallas/
    '';
  };

}

