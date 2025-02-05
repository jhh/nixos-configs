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
    flake.modules.nixos.j3ff-server
    inputs.strykeforce.nixosModules.default
    ./postgresql.nix
    ./strykeforce-sync.nix
    ./strykeforce-website.nix
  ];

  networking.hostName = "pallas";
  nixpkgs.hostPlatform = "x86_64-linux";

  environment.systemPackages = with pkgs; [
    perSystem.strykeforce.manage
  ];

  system.stateVersion = "21.11";
}
