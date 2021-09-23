{ config, pkgs, ... }:
{
  # system.activationScripts = {
  #   exports = ''
  #     mkdir -p /export/plex
  #     mkdir -p /export/proxmox
  #   '';
  # };

  # fileSystems."/export/plex/dl4cv" = {
  #   device = "/mnt/tank/media/plex/dl4cv";
  #   options = [ "bind" ];
  # };

  # fileSystems."/export/plex/movies" = {
  #   device = "/mnt/tank/media/plex/movies";
  #   options = [ "bind" ];
  # };

  # fileSystems."/export/plex/music" = {
  #   device = "/mnt/tank/media/plex/music";
  #   options = [ "bind" ];
  # };

  # fileSystems."/export/plex/photos" = {
  #   device = "/mnt/tank/media/plex/photos";
  #   options = [ "bind" ];
  # };

  # fileSystems."/export/plex/tv" = {
  #   device = "/mnt/tank/media/plex/tv";
  #   options = [ "bind" ];
  # };

  # fileSystems."/export/proxmox/pbs" = {
  #   device = "/mnt/tank/proxmox/pbs";
  #   options = [ "bind" ];
  # };

  # fileSystems."/export/proxmox/pve" = {
  #   device = "/mnt/tank/proxmox/pve";
  #   options = [ "bind" ];
  # };


  services.nfs.server = {
    enable = true;
    exports = ''
      /mnt/tank/media/plex  192.168.1.0/24(rw,insecure,sync,no_subtree_check,crossmnt)
      /mnt/tank/proxmox/pbs 192.168.1.47(rw,insecure,sync,no_subtree_check)
      /mnt/tank/proxmox/pve 192.168.1.20(rw,insecure,sync,no_subtree_check,no_root_squash) 192.168.1.21(rw,insecure,sync,no_subtree_check,no_root_squash)
    '';
  };

}
