{ lib, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.smartmontools
  ];

  services.smartd = {
    enable = true;
    notifications.test = true;
    defaults.autodetected = lib.concatStringsSep " " [
      "-s"
      "(L/../01/./02|S/../../2/01)"
      "-a"
      "-o"
      "off"
      "-n"
      "never"
      "-W"
      "2,40,45"
    ];
  };
}
