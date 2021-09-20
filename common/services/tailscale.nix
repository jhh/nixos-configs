{ config, lib, pkgs, ... }:
let
  unstable = import <nixos-unstable> { };
in
{
  options = {
    j3ff.tailscale = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  imports = [ <nixos-unstable/nixos/modules/services/networking/tailscale.nix> ];
  disabledModules = [ "services/networking/tailscale.nix" ];

  config = lib.mkIf config.j3ff.tailscale {

    environment.systemPackages = [
      unstable.tailscale
    ];

    nixpkgs.config = {
      packageOverrides = pkgs: {
        tailscale = unstable.tailscale;
      };
    };

    services.tailscale.enable = true;
  };
}
