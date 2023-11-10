{ config, pkgs, ... }:
{
  services.nfs.server = {
    enable = true;
    exports = ''
      /mnt/tank/backup/homeassistant 10.1.0.0/24(rw,insecure,sync,no_subtree_check)
      /mnt/tank/backup/postgres      10.1.0.0/24(rw,insecure,sync,no_subtree_check)
      /mnt/tank/backup/gitea         10.1.0.0/24(rw,insecure,sync,no_subtree_check,no_root_squash)
      /mnt/tank/share/homelab        192.168.1.0/24(rw,insecure,sync,no_subtree_check)
      /mnt/tank/media/plex           192.168.1.0/24(rw,insecure,sync,no_subtree_check,crossmnt) 10.1.0.0/24(rw,insecure,sync,no_subtree_check,crossmnt)
      /mnt/tank/proxmox/pbs          192.168.1.47(rw,insecure,sync,no_subtree_check)
      /mnt/tank/proxmox/pve          -rw,insecure,sync,no_subtree_check,no_root_squash 192.168.1.20 192.168.1.21 192.168.1.22 10.1.0.0/24
      /mnt/tank/services/gitea  1    0.1.0.0/24(rw,insecure,sync,no_subtree_check)
    '';
  };

}
