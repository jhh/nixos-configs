{ config, lib, pkgs, ... }:
let
  unstable = import <nixos-unstable> { };
in
{
  imports = [ <nixos-unstable/nixos/modules/services/networking/tailscale.nix> ];
  disabledModules = [ "services/networking/tailscale.nix" ];

  environment.systemPackages = [
    unstable.tailscale
  ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      tailscale = unstable.tailscale;
    };
  };

  services.tailscale.enable = true;
}
