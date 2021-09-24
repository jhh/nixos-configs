{ config, pkgs, ... }:
{
  fileSystems."/var/lib/plex" =
    { device = "rpool/local/plex";
      fsType = "zfs";
    };

  services.plex = {
    enable = true;
  };

}
