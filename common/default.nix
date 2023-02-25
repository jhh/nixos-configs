# common/default.nix
{ pkgs, lib, ... }:

{
  imports = [ ./users ./modules ];

  options = {
    j3ff.gui.enable = lib.mkEnableOption "GUI";
  };

  config = {
    boot = {
      loader.systemd-boot.configurationLimit = 10;
      cleanTmpDir = true;
    };

    environment.systemPackages = with pkgs; [
      bat
      file
      proxmox-backup-client
      nfs-utils
    ];

    networking.domain = "lan.j3ff.io";

    security.sudo.wheelNeedsPassword = false;
    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "America/Detroit";

    programs.fish.enable = true;

    services.openssh = {
      enable = true;
      passwordAuthentication = false;
    };

    services.resolved = {
      enable = true;
      dnssec = "false";
    };

    nixpkgs.config.allowUnfree = true;

    nix = {
      # package = pkgs.nixFlakes;
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
        options = "--delete-older-than 14d";
        randomizedDelaySec = "1h";
      };
    };
  };

}
