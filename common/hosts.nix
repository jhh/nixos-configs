{ config, lib, pkgs, ... }: {
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.cleanTmpDir = true;

  environment.systemPackages = with pkgs; [ bat file neovim wget curl ];

  networking.domain = "lan.j3ff.io";

  security.sudo.wheelNeedsPassword = false;
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Detroit";

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
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
