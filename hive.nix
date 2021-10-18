let
  sources = import nix/sources.nix;
in
{
  meta = {
    nixpkgs = import sources.nixpkgs { };
  };

  defaults = { pkgs, ... }: {

    imports = [
      (import "${sources.home-manager}/nixos")
      ./common/services
      ./common/users
    ];

    boot.loader.systemd-boot.configurationLimit = 10;
    environment.systemPackages = with pkgs; [ vim wget curl ];
    networking.domain = "lan.j3ff.io";

    security.sudo.wheelNeedsPassword = false;
    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "America/Detroit";

    services.openssh = {
      enable = true;
      permitRootLogin = "prohibit-password";
    };

    nixpkgs.config.allowUnfree = true;

    nix = {
      autoOptimiseStore = true;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
      package = pkgs.nixUnstable;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };

    home-manager.useGlobalPkgs = true;
    home-manager.users.jeff = { pkgs, ... }: { imports = [ ./home ]; };

    documentation.man.generateCaches = true;
  };

  eris = { pkgs, name, nodes, ... }: {
    networking.hostName = name;

    imports = [
      ./hosts/eris/configuration.nix
    ];

    j3ff = {
      mail.enable = true;
      prometheus.enable = true;
      smartd.enable = true;
      tailscale.enable = true;
      ups.enable = true;
      zfs = {
        enable = true;
        enableTrim = true;
      };
      zrepl.enable = true;
    };

    deployment = {
      allowLocalDeployment = true;
      targetHost = null;
    };
  };

  luna = { pkgs, name, nodes, ... }: {
    networking.hostName = name;

    imports = [
      ./hosts/luna/configuration.nix
    ];

    j3ff = {
      mail.enable = true;
      prometheus.enable = true;
      smartd.enable = true;
      tailscale.enable = true;
      ups.enable = true;
      zfs = {
        enable = true;
        enableTrim = false;
      };
      zrepl.enable = false; # zrepl server
    };

    deployment = {
      allowLocalDeployment = false;
      targetHost = "192.168.1.7";
    };
  };

  phobos = { pkgs, name, nodes, ... }: {
    networking.hostName = name;

    imports = [
      ./hosts/phobos/configuration.nix
    ];

    j3ff = {
      mail.enable = true;
      prometheus.enable = true;
      smartd.enable = true;
      tailscale.enable = true;
      ups.enable = false;
      zfs = {
        enable = true;
        enableTrim = false;
      };
      zrepl.enable = false; # zrepl server
    };

    deployment = {
      allowLocalDeployment = false;
      targetHost = "100.64.244.48";
    };
  };

  ceres = { name, nodes, ... }: {
    networking.hostName = name;

    imports = [
      ./hosts/ceres/configuration.nix
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

    deployment = {
      allowLocalDeployment = false;
      targetHost = "192.168.1.9";
    };
  };

  vesta = { name, nodes, ... }: {
    networking.hostName = name;

    imports = [
      ./hosts/vesta/configuration.nix
    ];

    j3ff = {
      mail.enable = true;
      tailscale.enable = true;
    };

    deployment = {
      allowLocalDeployment = false;
      targetHost = "192.168.1.45";
    };

  };
}
