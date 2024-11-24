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

  networking.hostName = "pallas";
  networking.domain = "lan.j3ff.io";
  proxmoxLXC.manageHostName = true;

  nix.settings = {
    substituters = [
      "https://strykeforce.cachix.org"
    ];

    trusted-public-keys = [
      "strykeforce.cachix.org-1:+ux184cQfS4lruf/lIzs9WDMtOkJIZI2FQHfz5QEIrE="
    ];
  };

  environment.systemPackages = with pkgs; [
    strykeforce-manage
  ];

  system.stateVersion = "21.11";
}
