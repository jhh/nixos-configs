# common/default.nix
{ pkgs, ... }:

{
  imports = [ ./users ./modules ];

  boot = {
    loader.systemd-boot.configurationLimit = 10;
    cleanTmpDir = true;
    tmpOnTmpfs = true;
  };

  environment.systemPackages = with pkgs; [
    age
    bat
    file
    minisign
    neovim
    nfs-utils
  ];

  networking.domain = "lan.j3ff.io";

  security.sudo.wheelNeedsPassword = false;
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Detroit";

  programs.fish.enable = true;

  services.openssh.enable = true;

  services.resolved = {
    enable = true;
    dnssec = "false";
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings = {
      auto-optimise-store = true;
      trusted-users = [ "root" "jeff" ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 90d";
      randomizedDelaySec = "1h";
    };
  };
}
