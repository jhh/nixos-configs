{
  flake,
  inputs,
  lib,
  ...
}:
{
  imports = [
    flake.modules.nixos.hardware-proxmox-lxc
    inputs.puka.nixosModules.puka
    flake.modules.nixos.server-j3ff
    ./caddy.nix
    # ./calibre.nix
    ./gitea.nix
    ./miniflux.nix
    ./paperless.nix
    ./postgresql.nix
    ./puka.nix
  ];

  networking.hostName = "eris";
  networking.firewall.enable = lib.mkForce false;

  system.stateVersion = "23.11";
}
