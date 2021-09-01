{
  meta = {
    nixpkgs = <nixos-unstable>;
  };

  defaults = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ vim wget curl ];

    security.sudo.wheelNeedsPassword = false;
    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "America/Detroit";

    services.openssh = {
      enable = true;
      permitRootLogin = "yes";
    };

    nixpkgs.config.allowUnfree = true;
    nix.autoOptimiseStore = true;
    nix.gc = {
      automatic = true;
      dates = "daily";
    };

  };

  eris = { name, nodes, ... }: {
    networking.hostName = name;

    imports = [
      <home-manager/nixos>
      ./common/users
      ./hosts/eris/configuration.nix
      ./hosts/eris/grafana.nix
      ./hosts/eris/prometheus.nix
    ];

    home-manager.useGlobalPkgs = true;
    home-manager.users.jeff = { pkgs, ... }: { imports = [ ./home ]; };

    deployment = {
      allowLocalDeployment = true;
      targetHost = null;
    };
  };

  nixos-01 = { name, nodes, ... }: {
    networking.hostName = name;

    imports = [
      <home-manager-unstable/nixos>
      ./common/users
      ./hosts/nixos-01/configuration.nix
    ];

    home-manager.useGlobalPkgs = true;
    home-manager.users.jeff = { pkgs, ... }: { imports = [ ./home ]; };

    deployment = {
      allowLocalDeployment = false;
      targetHost = "192.168.1.182";
    };
  };

  nixos-03 = { name, nodes, ... }: {
    networking.hostName = name;

    imports = [
      ./hosts/nixos-03/configuration.nix
      ./common/users
      <home-manager-unstable/nixos>
    ];

    home-manager.useGlobalPkgs = true;
    home-manager.users.jeff = { pkgs, ... }: { imports = [ ./home ]; };

    deployment = { targetHost = "192.168.1.118"; };
  };

}

