{
  meta = {
    # Override to pin the Nixpkgs version (recommended). This option
    # accepts one of the following:
    # - A path to a Nixpkgs checkout
    # - The Nixpkgs lambda (e.g., import <nixpkgs>)
    # - An initialized Nixpkgs attribute set
    nixpkgs = <nixpkgs>;

  };

  defaults = { pkgs, ... }: {
    # This module will be imported by all hosts
    environment.systemPackages = with pkgs; [
      vim wget curl
    ];

    security.sudo.wheelNeedsPassword = false;
    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "America/Detroit";

    services.openssh = {
      enable = true;
      permitRootLogin = "yes";
    };
  };

  nixos-01 = { name, nodes, ... }: {
    networking.hostName = name;

    imports = [ ./hosts/nixos-01/configuration.nix ];

    deployment = {
      allowLocalDeployment = true;
      targetHost = null;
    };
  };

}

