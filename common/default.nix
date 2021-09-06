# common/default.nix
{ ... }:

{
  imports = [
    ./users
    ./ssd.nix
  ];

  boot.cleanTmpDir = true;

  nix.autoOptimiseStore = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=7day
  '';

  services.resolved = {
    enable = true;
    dnssec = "false";
  };

  time.timeZone = "America/Detroit";
  i18n.defaultLocale = "en_US.UTF-8";

}
