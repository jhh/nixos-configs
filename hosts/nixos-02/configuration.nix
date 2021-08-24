{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../common
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.kernelParams = [
    "console=ttyS0,115200"
    "console=tty1"
  ];
  services.qemuGuest.enable = true;

  networking.hostName = "nixos-02";
  time.timeZone = "America/Detroit";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.useDHCP = false;
  networking.interfaces.ens18.useDHCP = true;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqpWpNJzfzioGYyR9q4wLwPkBrnmc/Gdl6JsO+SUpel jeff@j3ff.io"
  ];

  environment.systemPackages = with pkgs; [
    vim
  ];

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

  j3ff = {
    ssd.enable = true;
  };

}

