{ config, pkgs, ... }:
{
  systemd.services.jeff-backup = {

    startAt = "hourly";

    environment = {
      BACKUP_HOST = "luna.ts.j3ff.io";
      RSYNC_RSH = "${pkgs.openssh}/bin/ssh";
    };

    script = ''
      echo backing up /home/jeff
      ${pkgs.rsync}/bin/rsync -az /home/jeff jeff@$BACKUP_HOST:backup/pallas/
    '';
  };

}

