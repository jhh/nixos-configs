{ config, pkgs, ... }:

{
  imports =
    [
      ./vm-intel.nix
      ./hardware-configuration.nix
    ];

  j3ff = {
    mail.enable = false;
    tailscale.enable = false;
  };

}

