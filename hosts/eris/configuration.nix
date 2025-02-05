{
  flake,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    flake.modules.nixos.hardware-proxmox-lxc
    inputs.srvos.nixosModules.mixins-nginx
    inputs.puka.nixosModules.default
    inputs.upkeep.nixosModules.default
    flake.modules.nixos.j3ff-server
    ./gitea.nix
    ./miniflux.nix
    ./nginx.nix
    ./paperless.nix
    ./postgresql.nix
    ./puka.nix
    ./upkeep.nix
  ];

  networking.hostName = "eris";
  nixpkgs.hostPlatform = "x86_64-linux";

  system.stateVersion = "23.11";
}
