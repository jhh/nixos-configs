{ config, lib, pkgs, ... }:
let
  cfg = config.j3ff.zfs;
in
{
  options = {
    j3ff.zfs = {
      enable = lib.mkEnableOption "ZFS";

      scrub = lib.mkOption {
        type = lib.types.str;
        default = "monthly";
        description = ''
          Systemd calendar expression when to scrub ZFS pools. See systemd.time
          (7).
        '';
      };

      enableTrim = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable periodic TRIM on all ZFS pools.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.zfs = {
      autoScrub = {
        enable = true;
        interval = cfg.scrub;
      };

      autoSnapshot = {
        enable = false;
        flags = "--keep-zero-sized-snapshots --parallel-snapshots --utc";
      };

      trim.enable = cfg.enableTrim;

      zed = lib.mkIf config.j3ff.mail.enable {
        enableMail = false;
        settings = {
          ZED_EMAIL_ADDR = [ "root" ];
          ZED_EMAIL_PROG = "${pkgs.mailutils}/bin/mail";
          ZED_EMAIL_OPTS = "-s '@SUBJECT@' @ADDRESS@";

          ZED_NOTIFY_INTERVAL_SECS = 3600;
          ZED_NOTIFY_VERBOSE = true;

          ZED_USE_ENCLOSURE_LEDS = true;
          ZED_SCRUB_AFTER_RESILVER = false;
        };
      };
    };

    # Use native ZFS compression
    services.journald.extraConfig = ''
      Compress=false
    '';
  };
}
