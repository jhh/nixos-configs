{ config, modulesPath, pkgs, ... }:
{
  imports =
    [
      (modulesPath + "/virtualisation/proxmox-lxc.nix")
      ./media.nix
    ];

  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-wrapped-6.0.36"
    "aspnetcore-runtime-6.0.36"
    "dotnet-sdk-wrapped-6.0.428"
    "dotnet-sdk-6.0.428"
  ];

  networking.hostName = "ceres";
  networking.domain = "lan.j3ff.io";
  proxmoxLXC.manageHostName = true;

  boot.tmp.cleanOnBoot = true;
  networking.firewall.enable = false;

  j3ff = {
    mail.enable = true;
    man.enable = false;
    mdns.enable = true;
    prometheus.enable = true;
    tailscale.enable = false;
    services.fava-yoyodyne.enable = false;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
