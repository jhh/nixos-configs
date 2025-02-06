{ pkgs, ... }:
{
  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "monthly";
    };

    autoSnapshot = {
      enable = false;
      flags = "--keep-zero-sized-snapshots --parallel-snapshots --utc";
    };

    trim.enable = true;

    zed = {
      enableMail = true;
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
}
