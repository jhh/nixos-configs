{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./zinc.nix
    ];

  j3ff = {
    mail.enable = true;
    prometheus.enable = true;
    smartd.enable = true;
    tailscale.enable = true;
    ups.enable = true;
    virtualization.enable = true;
    zfs = {
      enable = true;
      enableTrim = true;
    };
    zrepl.enable = true;
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    video.hidpi.enable = true;
  };

  boot = {
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    kernel.sysctl = {
      "net.bridge.bridge-nf-call-ip6tables" = 0;
      "net.bridge.bridge-nf-call-iptables" = 0;
      "net.bridge.bridge-nf-call-arptables" = 0;
      "net.bridge.bridge-nf-filter-vlan-tagged" = 0;
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "zfs" ];
  };

  networking =
    {
      hostName = "ceres";
      useDHCP = false;
      bridges."br0" = {
        interfaces = [
          "eno1"
        ];
      };
      interfaces.br0 = {
        useDHCP = false;
        ipv4.addresses = [{
          address = "192.168.1.9";
          prefixLength = 24;
        }];
      };
      defaultGateway = "192.168.1.1";
      nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" ];
      hostId = "96a5b0e0";
      firewall.enable = false;
    };

  fileSystems."/mnt" =
    {
      device = "tank";
      fsType = "zfs";
    };

  environment.systemPackages = with pkgs; [
    firefox
    killall
    xclip
  ];

  services.xserver = {
    enable = true;
    xkbOptions = "ctrl:swapcaps";

    videoDrivers = [ "intel" ];
    useGlamor = true;

    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
      defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
      ];
    };
  };

  fonts = {
    fontDir.enable = true;

    fonts = [
      (builtins.path {
        name = "custom-fonts";
        path = ../../secret/fonts;
        recursive = true;
      })
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}
