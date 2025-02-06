{ config, pkgs, ... }:
{
  services.nfs.server = {
    enable = true;
    exports = ''
      /mnt/tank/proxmox/pve   192.168.3.2(rw,insecure,sync,no_subtree_check,no_root_squash)
    '';
  };

  networking.firewall.allowedTCPPorts = [ 2049 ];
}
