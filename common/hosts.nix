{ config, lib, pkgs, ... }: {
  boot = {
    loader.systemd-boot.configurationLimit = 10;
    cleanTmpDir = true;
    tmpOnTmpfs = true;
  };


  environment.systemPackages = with pkgs; [ bat file neovim wget curl ];

  networking.domain = "lan.j3ff.io";

  security.sudo.wheelNeedsPassword = false;
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Detroit";

  programs.fish.enable = true;

  services.openssh = {
    enable = true;
    permitRootLogin = "prohibit-password";
  };

  services.resolved = {
    enable = true;
    dnssec = "false";
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
      randomizedDelaySec = "1h";
    };
    nixPath = [
      "nixpkgs=${pkgs.path}"
      # "home-manager=${home-manager}"
    ];
    package = pkgs.nix_2_4;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
