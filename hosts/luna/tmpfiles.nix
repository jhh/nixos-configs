{ config, pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "d /mnt/tank/backup/paperless 0775 ${config.users.users.paperless} media - -"
  ];
}
