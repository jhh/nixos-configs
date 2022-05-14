{ config, pkgs, ... }:
{
  services.nfs.server = {
    enable = true;
    exports = ''
      /mnt/tank/backup/postgres 192.168.1.0/24(rw,insecure,sync,no_subtree_check)
      /mnt/tank/share/homelab   192.168.1.0/24(rw,insecure,sync,no_subtree_check)
      /mnt/tank/media/plex      192.168.1.0/24(rw,insecure,sync,no_subtree_check,crossmnt)
      /mnt/tank/proxmox/pbs     192.168.1.47(rw,insecure,sync,no_subtree_check)
      /mnt/tank/proxmox/pve     -rw,insecure,sync,no_subtree_check,no_root_squash 192.168.1.20 192.168.1.21 192.168.1.22
    '';
  };

}
