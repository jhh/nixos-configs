{ strykeforce, config, modulesPath, pkgs, ... }:
let
  strykeforce-manage = strykeforce.packages.${pkgs.system}.manage;
in
{

  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ./postgresql.nix
    ./strykeforce-sync.nix
    ./strykeforce-website.nix
  ];

  system.name = "pallas";
  boot.tmp.cleanOnBoot = true;
  networking.firewall.enable = false;

  environment.systemPackages = with pkgs; [
    strykeforce-manage
  ];

  system.stateVersion = "21.11";
}
