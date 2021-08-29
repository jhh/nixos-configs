{
  meta = {
    # Override to pin the Nixpkgs version (recommended). This option
    # accepts one of the following:
    # - A path to a Nixpkgs checkout
    # - The Nixpkgs lambda (e.g., import <nixpkgs>)
    # - An initialized Nixpkgs attribute set
    nixpkgs = <nixos-unstable>;

    nodeNixpkgs = {
      eris = <nixos>;
    };
  };

  defaults = { pkgs, ... }: {
    # This module will be imported by all hosts
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

    imports =
      [ <home-manager/nixos> ./common/users ./hosts/eris/configuration.nix ];

    home-manager.useGlobalPkgs = true;
    home-manager.users.jeff = { pkgs, ... }: {
      imports = [ ./common/home.nix ];
    };

    deployment = {
      allowLocalDeployment = true;
      targetHost = null;
    };
  };

  nixos-01 = { name, nodes, ... }: {
    networking.hostName = name;

    imports = [
      <home-manager/nixos>
      ./common/users
      ./hosts/nixos-01/configuration.nix
    ];

    home-manager.useGlobalPkgs = true;
    home-manager.users.jeff = { pkgs, ... }: {
      imports = [ ./common/home.nix ];
    };

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
      <home-manager/nixos>
    ];

    home-manager.useGlobalPkgs = true;
    home-manager.users.jeff = { pkgs, ... }: {
      imports = [ ./common/home.nix ];
    };

    deployment = { targetHost = "192.168.1.118"; };
  };

}

