{ strykeforce, config, pkgs, ... }:
let

  strykeforce-manage = strykeforce.packages.${pkgs.system}.manage;
in
{

  imports = [
    ./hardware-configuration.nix
    ./postgresql.nix
    ./strykeforce-website.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  environment.systemPackages = with pkgs; [
    bat
    git
    nixfmt
    strykeforce-manage
  ];

  networking = {
    hostName = "pallas";
    domain = "lan.j3ff.io";
    useDHCP = false;

    interfaces.ens18 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "10.1.0.47";
        prefixLength = 24;
      }];
    };

    defaultGateway = "10.1.0.1";
    nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" ];
    firewall.enable = false;
  };

  services = {
    fstrim.enable = true;
    qemuGuest.enable = true;
  };


  system.stateVersion = "21.11";
}
