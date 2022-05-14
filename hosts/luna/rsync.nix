{ config, pkgs, ... }:
{
  systemd.services.deimos-backup = {
    startAt = "*-*-* 02:20:00";

    environment = {
      RSYNC_RSH = "${pkgs.openssh}/bin/ssh";
    };

    script = ''
      echo backing up /mnt/tank/share/jeff
      ${pkgs.rsync}/bin/rsync -av /mnt/tank/share/jeff sshd@deimos:/mnt/HD/HD_a2/daily/home

      echo backing up /mnt/tank/share/homelab
      ${pkgs.rsync}/bin/rsync -av /mnt/tank/share/homelab sshd@deimos:/mnt/HD/HD_a2/daily

      echo backing up /mnt/tank/backup/git
      ${pkgs.rsync}/bin/rsync -av /mnt/tank/backup/git sshd@deimos:/mnt/HD/HD_a2/daily

      echo backing up /mnt/tank/media/lightroom
      ${pkgs.rsync}/bin/rsync -av --delete /mnt/tank/media/lightroom sshd@deimos:/mnt/HD/HD_a2/daily

      echo backing up /mnt/tank/media/pictures
      ${pkgs.rsync}/bin/rsync -av --delete /mnt/tank/media/pictures sshd@deimos:/mnt/HD/HD_a2/daily

      echo backing up /mnt/tank/media/plex
      ${pkgs.rsync}/bin/rsync -av --delete /mnt/tank/media/plex/ sshd@deimos:/mnt/HD/HD_a2/daily/plex

      echo backing up /mnt/tank/backup/postgres
      ${pkgs.rsync}/bin/rsync -av --delete /mnt/tank/backup/postgres/ sshd@deimos:/mnt/HD/HD_a2/daily/postgres
    '';
  };

}

