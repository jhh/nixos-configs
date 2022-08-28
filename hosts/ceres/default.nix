{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  environment.systemPackages = with pkgs; [
    firefox
  ];

  j3ff = {
    gui.enable = true;
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

  deadeye = {
    web.enable = true;
    admin.enable = true;
    daemon = {
      enable = true;
      unitId = "C";
      pipeline0 = "deadeye::UprightRectPipeline";
      pipeline1 = "deadeye::MinAreaRectPipeline";
      pipeline2 = "deadeye::TargetListPipeline";
      streamAddress = "${(builtins.head config.networking.interfaces.br0.ipv4.addresses).address}";
    };
    ntServerAddress = "100.78.167.19"; # luna
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    video.hidpi.enable = true;
  };

  services.thermald.enable = true;

  boot = {
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "zfs" ];
    zfs.devNodes = "/dev/";
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
          address = "10.1.0.10";
          prefixLength = 24;
        }];
      };
      defaultGateway = "10.1.0.1";
      nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" ];
      hostId = "88c43f5a";
      firewall.enable = false;
      wireless.enable = false;
    };

  services.xserver = {
    enable = false;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
    displayManager.defaultSession = "xfce";
  };

  services.picom = {
    enable = true;
    fade = true;
    inactiveOpacity = 0.9;
    shadow = true;
    fadeDelta = 4;
  };

  services.gnome.gnome-keyring.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # fileSystems."/mnt" =
  #   {
  #     device = "tank";
  #     fsType = "zfs";
  #   };



  # fonts = {
  #   fontDir.enable = true;

  #   fonts = [
  #     (builtins.path {
  #       name = "custom-fonts";
  #       path = ../../secret/fonts;
  #       recursive = true;
  #     })
  #   ];
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}
