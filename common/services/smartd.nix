{ config, lib, pkgs, ... }:
{
  options = {
    j3ff.smartd.enable = lib.mkEnableOption "SMART disk monitoring";
  };

  config = lib.mkIf config.j3ff.smartd.enable {
    environment.systemPackages = [
      pkgs.smartmontools
    ];

    services.smartd = {
      enable = true;
      notifications.test = true;
      defaults.autodetected = lib.concatStringsSep " " [
        "-s" "(L/../01/./02|S/../../2/01|O/../.././(00|08|16))"
        "-a"
        "-o" "off"
        "-n" "never"
        "-W" "2,40,45"
      ];
    };
  };
}
