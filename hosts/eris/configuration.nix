{
  flake,
  inputs,
  lib,
  ...
}:
{
  imports = [
    flake.modules.nixos.hardware-proxmox-lxc
    inputs.srvos.nixosModules.mixins-nginx
    inputs.puka.nixosModules.puka
    inputs.upkeep.nixosModules.default
    flake.modules.nixos.server-j3ff
    ./gitea.nix
    ./miniflux.nix
    ./nginx.nix
    ./paperless.nix
    ./postgresql.nix
    ./puka.nix
    ./upkeep.nix
  ];

  networking.hostName = "eris";
  networking.firewall.enable = lib.mkForce false;

  system.stateVersion = "23.11";
}
