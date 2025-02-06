{
  flake,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    flake.modules.nixos.hardware-proxmox-vm
    flake.modules.nixos.server-j3ff
    flake.modules.nixos.home-manager-jeff
  ];

  networking.hostName = "styx";

  networking.interfaces.ens18.ipv4.addresses = [
    {
      address = "10.1.0.49";
      prefixLength = 24;
    }
  ];

  system.stateVersion = "24.11";
}
