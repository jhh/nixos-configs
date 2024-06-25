{ config, pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "d /mnt/tank/backup/paperless 0775 paperless media - -"
  ];
}
