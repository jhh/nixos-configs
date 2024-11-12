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
      tmp.cleanOnBoot = true;
    };

    environment.systemPackages = with pkgs; [
      bat
      file
      # proxmox-backup-client
      nfs-utils
      nodejs
    ];

    networking.domain = "lan.j3ff.io";

    security.sudo.wheelNeedsPassword = false;
    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "US/Michigan";

    programs.fish.enable = true;

    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
      };
    };

    services.resolved = {
      enable = true;
      dnssec = "false";
    };

    nixpkgs.config.allowUnfree = true;

    nix = {
      package = pkgs.nixVersions.git;
      extraOptions = ''
        experimental-features = nix-command flakes
        cores = 0
      '';

      settings = {
        auto-optimise-store = pkgs.stdenv.isLinux;
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
