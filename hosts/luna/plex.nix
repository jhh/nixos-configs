{ config, pkgs, ... }:
{
  fileSystems."/var/lib/plex" = {
    device = "rpool/local/plex";
    fsType = "zfs";
  };

  users.users.plex.extraGroups = [ "media" ];

  services.plex = {
    enable = true;
    openFirewall = true;
  };

  nixpkgs.config.allowUnfree = true;
}
