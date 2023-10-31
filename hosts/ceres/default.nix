{ flakes, config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./media.nix
    ];

  j3ff = {
    mail.enable = true;
    man.enable = false;
    mdns.enable = true;
    prometheus.enable = true;
    tailscale.enable = true;
    services.fava-gencon.enable = false;
  };

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  zramSwap.enable = true;

  networking = {
    hostName = "ceres";
    useNetworkd = true;
    useDHCP = false;

    interfaces.ens18 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "10.1.0.44";
        prefixLength = 24;
      }];
    };

    defaultGateway = {
      address = "10.1.0.1";
      interface = "ens18";
    };

    nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" ];
    firewall.enable = false;
  };

  services = {
    fstrim.enable = true;
    qemuGuest.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}
