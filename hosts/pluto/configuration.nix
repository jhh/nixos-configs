{
  flake,
  ...
}:
{
  imports = [
    flake.modules.nixos.hardware-proxmox-lxc
    flake.modules.nixos.j3ff-server
  ];

  networking.hostName = "pluto";
  nixpkgs.hostPlatform = "x86_64-linux";

  system.stateVersion = "24.11";
}
