{ config, modulesPath, pkgs, ... }:
{
  imports =
    [
      (modulesPath + "/virtualisation/proxmox-lxc.nix")
      ./postgresql.nix
      ./nginx.nix
      ./gitea.nix
      ./miniflux.nix
    ];

  system.name = "eris";
  boot.tmp.cleanOnBoot = true;
  networking.firewall.enable = false;

  age.secrets.puka_secrets = {
    file = ../../secrets/puka_secrets.age;
  };

  j3ff = {
    mail.enable = true;
    man.enable = false;
    mdns.enable = true;
    prometheus.enable = true;
    puka.enable = true;
    tailscale.enable = false;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
