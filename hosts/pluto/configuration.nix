{
  flake,
  ...
}:
{
  imports = [
    flake.modules.nixos.hardware-proxmox-lxc
    flake.modules.nixos.server-j3ff
  ];

  networking.hostName = "pluto";
  nixpkgs.hostPlatform = "x86_64-linux";

  system.stateVersion = "24.11";
}
