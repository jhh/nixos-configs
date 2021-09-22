{ config, pkgs, ... }:
{
  system.activationScripts = {
    exports = "mkdir -p /export/plex";
  };

  fileSystems."/export/plex/dl4cv" = {
    device = "/mnt/tank/media/plex/dl4cv";
    options = [ "bind" ];
  };

  fileSystems."/export/plex/movies" = {
    device = "/mnt/tank/media/plex/movies";
    options = [ "bind" ];
  };

  fileSystems."/export/plex/music" = {
    device = "/mnt/tank/media/plex/music";
    options = [ "bind" ];
  };

  fileSystems."/export/plex/photos" = {
    device = "/mnt/tank/media/plex/photos";
    options = [ "bind" ];
  };

  fileSystems."/export/plex/tv" = {
    device = "/mnt/tank/media/plex/tv";
    options = [ "bind" ];
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /export 192.168.1.0/24(rw,fsid=0,no_subtree_check)
      /export/plex 192.168.1.0/24(rw,insecure,sync,no_subtree_check,crossmnt)
    '';
  };

}
