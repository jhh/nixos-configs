{ config, modulesPath, pkgs, ... }: {

  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];

  boot.tmp.cleanOnBoot = true;
  networking.firewall.enable = false;

  system.stateVersion = "23.11";
}
