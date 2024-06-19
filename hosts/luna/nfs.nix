{ config, pkgs, ... }:
{
  services.nfs.server = {
    enable = true;
    exports = ''
      /mnt/tank/backup/homeassistant 10.1.0.0/24(rw,insecure,sync,no_subtree_check)
      /mnt/tank/backup/postgres      10.1.0.0/24(rw,insecure,sync,no_subtree_check)
      /mnt/tank/backup/gitea         10.1.0.0/24(rw,insecure,sync,no_subtree_check,no_root_squash)
      /mnt/tank/share/homelab        10.1.0.0/24(rw,insecure,sync,no_subtree_check)
      /mnt/tank/share/paperless      10.1.0.0/24(rw,insecure,sync,no_subtree_check)
      /mnt/tank/media/paperless      10.1.0.0/24(rw,insecure,sync,no_subtree_check)
      /mnt/tank/media/plex           10.1.0.0/24(rw,insecure,sync,no_subtree_check,crossmnt)
      /mnt/tank/proxmox/pbs          10.1.0.9(rw,insecure,sync,no_subtree_check)
      /mnt/tank/proxmox/pve          -rw,insecure,sync,no_subtree_check,no_root_squash 10.1.0.9 10.1.0.11
    '';
  };

}
