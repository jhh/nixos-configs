{
  meta = {
    nixpkgs = <nixos-unstable>;

    nodeNixpkgs = {
      ceres = <nixos>;
    };
  };

  defaults = { pkgs, ... }: {
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
      ./common/services
      ./common/users
      ./hosts/ceres/configuration.nix
    ];

    j3ff = {
      tailscale = true;
      ups = true;
      zrepl = true;
    };

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
      mail = true;
      tailscale = true;
      ups = true;
      zrepl = true;
    };

    documentation.man.generateCaches = true;

    home-manager.useGlobalPkgs = true;
    home-manager.users.jeff = { pkgs, ... }: { imports = [ ./home ]; };

    deployment = {
      allowLocalDeployment = true;
      targetHost = null;
    };
  };

  luna = { name, nodes, ... }: {
    networking.hostName = name;

    imports = [
      ./hosts/luna/configuration.nix
      ./common/services
      ./common/services/zrepl/server.nix
      ./common/users
    ];

    j3ff = {
      mail = true;
      tailscale = true;
      ups = true;
      zrepl = false; # zrepl server
    };

    deployment = {
      allowLocalDeployment = false;
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
      mail = true;
      tailscale = true;
    };


    home-manager.useGlobalPkgs = true;
    home-manager.users.jeff = { pkgs, ... }: { imports = [ ./home ]; };

    deployment = {
      allowLocalDeployment = false;
      targetHost = "192.168.1.182";
    };
  };
}

