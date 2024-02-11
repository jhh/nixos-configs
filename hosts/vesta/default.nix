{ config, modulesPath, pkgs, ... }:

{
  imports =
    [
      (modulesPath + "/virtualisation/proxmox-lxc.nix")
      ./rsync.nix
    ];

  boot.tmp.cleanOnBoot = true;
  networking.firewall.enable = false;

  age.secrets.stryker_website_secrets = {
    file = ../../secrets/strykeforce_website_secrets.age;
  };

  j3ff = {
    dyndns.enable = false;
    mail.enable = true;
    tailscale.enable = false;
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
        pihole.enable = false;
        unifi.enable = true;
      };
    };
  };

  # virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
