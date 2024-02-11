{ strykeforce, config, modulesPath, pkgs, ... }:
let
  strykeforce-manage = strykeforce.packages.${pkgs.system}.manage;
in
{

  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ./aws.nix
    ./postgresql.nix
    ./strykeforce-website.nix
  ];

  boot.tmp.cleanOnBoot = true;
  networking.firewall.enable = false;

  environment.systemPackages = with pkgs; [
    bat
    nixfmt
    strykeforce-manage
  ];

  system.stateVersion = "21.11";
}
