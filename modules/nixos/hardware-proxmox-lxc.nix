{ inputs, modulesPath, ... }:
{
  #
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    inputs.srvos.nixosModules.server
  ];

  proxmoxLXC.manageHostName = true;

  nix.optimise.automatic = true;

  services = {
    fstrim.enable = true;
    getty.autologinUser = "root";
  };
}
