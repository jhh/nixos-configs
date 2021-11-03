{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./rsync.nix
    ./vm-intel.nix
  ];

  j3ff = {
    mail.enable = true;
    tailscale.enable = true;
  };

}

