{ config, pkgs, ... }:

{
  imports = [
    ./vm-intel.nix
    ./hardware-configuration.nix
    ./rsync.nix
  ];

  j3ff = {
    mail.enable = false;
    tailscale.enable = false;
  };

}

