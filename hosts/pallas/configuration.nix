{
  flake,
  inputs,
  pkgs,
  perSystem,
  ...
}:
{
  imports = [
    flake.modules.nixos.hardware-proxmox-lxc
    inputs.srvos.nixosModules.mixins-nginx
    flake.modules.nixos.server-j3ff
    inputs.strykeforce.nixosModules.strykeforce-website
    ./postgresql.nix
    ./strykeforce-sync.nix
    ./strykeforce-website.nix
  ];

  networking.hostName = "pallas";
  nixpkgs.hostPlatform = "x86_64-linux";

  system.stateVersion = "21.11";
}
