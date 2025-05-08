{
  inputs,
  lib,
  modulesPath,
  ...
}:
{
  #
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    inputs.srvos.nixosModules.server
  ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  proxmoxLXC.manageHostName = true;
  nix.optimise.automatic = true;

  services = {
    fstrim.enable = true;
    getty.autologinUser = "root";
  };
}
