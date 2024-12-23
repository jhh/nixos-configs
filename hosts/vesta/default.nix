{ config, modulesPath, pkgs, ... }:

{
  imports =
    [
      (modulesPath + "/virtualisation/proxmox-lxc.nix")
      ./rsync.nix
    ];

  system.name = "vesta";
  boot.tmp.cleanOnBoot = true;
  networking.firewall.enable = false;

  networking.hostName = "vesta";
  networking.domain = "lan.j3ff.io";
  proxmoxLXC.manageHostName = true;

  age.secrets.stryker_website_secrets = {
    file = ../../secrets/strykeforce_website_secrets.age;
  };

  j3ff = {
    dyndns.enable = false;
    mail.enable = true;
    tailscale.enable = true;
    man.enable = true;
    mdns.enable = true;
    prometheus.enable = true;
    watchtower = {
      alertmanager.enable = true;
      prometheus.enable = true;
      pushgateway.enable = true;
      grafana.enable = true;
      exporters = {
        nut.enable = true;
        pihole.enable = true;
        unifi.enable = true;
      };
    };
  };

  nix.settings = {
    substituters = [
      "https://strykeforce.cachix.org"
    ];

    trusted-public-keys = [
      "strykeforce.cachix.org-1:+ux184cQfS4lruf/lIzs9WDMtOkJIZI2FQHfz5QEIrE="
    ];
  };

  documentation.nixos.enable = true;
  documentation.nixos.includeAllModules = true;
  documentation.nixos.options.warningsAreErrors = false;

  # virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
