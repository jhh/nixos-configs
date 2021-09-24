{
  meta = {
    nixpkgs = import <nixos-unstable> { };
  };

  defaults = { pkgs, ... }: {
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
        options = "--delete-older-than 6w --max-freed 256M";
      };
    };

  };

  ceres = { name, nodes, ... }: {
    networking.hostName = name;

    imports = [
      <home-manager/nixos>
      ./common/services
      ./common/users
      ./hosts/ceres/configuration.nix
    ];

    j3ff = {
      mail.enable = true;
      smartd.enable = true;
      tailscale.enable = true;
      ups.enable = true;
      zfs = {
        enable = true;
        enableTrim = true;
      };
      zrepl.enable = true;
    };

    home-manager.useGlobalPkgs = true;
    home-manager.users.jeff = { pkgs, ... }: { imports = [ ./home ]; };

    deployment = {
      allowLocalDeployment = false;
      targetHost = "192.168.1.9";
    };
  };

  eris = { name, nodes, ... }: {
    networking.hostName = name;

    imports = [
      <home-manager/nixos>
      ./common/services
      ./common/users
      ./hosts/eris/configuration.nix
      ./hosts/eris/grafana.nix
      ./hosts/eris/prometheus.nix
    ];

    j3ff = {
      mail.enable = true;
      smartd.enable = true;
      tailscale.enable = true;
      ups.enable = true;
      zfs = {
        enable = true;
        enableTrim = true;
      };
      zrepl.enable = true;
    };

    documentation.man.generateCaches = true;

    home-manager.useGlobalPkgs = true;
    home-manager.users.jeff = { pkgs, ... }: { imports = [ ./home ]; };

    deployment = {
      allowLocalDeployment = true;
      targetHost = null;
    };
  };

  luna = { pkgs, name, nodes, ... }: {
    networking.hostName = name;

    imports = [
      <home-manager/nixos>
      ./hosts/luna/configuration.nix
      ./hosts/luna/nfs.nix
      ./hosts/luna/plex.nix
      ./hosts/luna/samba.nix
      ./common/services
      ./common/services/zrepl/server.nix
      ./common/users
    ];

    j3ff = {
      mail.enable = true;
      smartd.enable = true;
      tailscale.enable = true;
      ups.enable = true;
      zfs = {
        enable = true;
        enableTrim = false;
      };
      zrepl.enable = false; # zrepl server
    };

    # ZFS
    boot.kernelParams = [ "zfs.zfs_arc_max=29344391168" ];

    # Prometheus
    services.prometheus = {
        exporters = {
          node = {
            enable = true;
            enabledCollectors = [ "systemd" "processes" "nfs" "nfsd" ];
            port = 9002;
          };
        };
      };

    home-manager.useGlobalPkgs = true;
    home-manager.users.jeff = { pkgs, ... }: { imports = [ ./home ]; };

    deployment = {
      allowLocalDeployment = true;
      targetHost = "192.168.1.7";
    };
  };

  nixos-01 = { config, name, nodes, ... }: {
    networking.hostName = name;

    networking.hosts."127.0.0.1" = [
      "${config.networking.hostName}.${config.networking.domain}"
      config.networking.hostName
    ];

    imports = [
      ./hosts/nixos-01/configuration.nix
      <home-manager/nixos>
      ./common/users
      ./common/services
    ];

    j3ff = {
      mail.enable = true;
      mdns.enable = false;
      smartd.enable = false;
      tailscale.enable = true;
      ups.enable = false;
      zfs.enable = true;
    };


    home-manager.useGlobalPkgs = true;
    home-manager.users.jeff = { pkgs, ... }: { imports = [ ./home ]; };

    deployment = {
      allowLocalDeployment = false;
      targetHost = "192.168.1.182";
    };
  };
}

