{
  flake,
  ...
}:
{
  imports = [
    flake.modules.nixos.hardware-proxmox-lxc
    flake.modules.nixos.server-j3ff
    ./blocky.nix
  ];

  networking.hostName = "pluto";

  system.stateVersion = "24.11";
}
