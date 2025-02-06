{ config, pkgs, ... }:
{

  users.users.jerry = {
    isNormalUser = true;
    home = "/home/jerry";
    description = "Jerry Culp";
    hashedPassword = "$y$j9T$3OHmH5sCtzdckdk0eBwEN1$czyKEtxf/kv24.B3Amyc0uFQCSKQv7FQ1Tzu421YD56";
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    settings.global = {
      "workgroup" = "WORKGROUP";
      "server string" = "Phobos";
      "netbios name" = "PHOBOS";
      "security" = "user";
      "min protocol" = "SMB2";
      "ea support" = "yes";
      "logging" = "0";

      "vfs objects" = "fruit streams_xattr";
      "fruit:aapl" = "yes";
      "fruit:metadata" = "stream";
      "fruit:model" = "MacSamba";
      "fruit:veto_appledouble" = "no";
      "fruit:nfs_aces" = "no";
      "fruit:wipe_intentionally_left_blank_rfork" = "yes";
      "fruit:delete_empty_adfiles" = "yes";
      "fruit:posix_rename" = "yes";

      "hosts allow" = [
        "192.168.3.0/24"
        "100.64.0.0/10"
        "100.69.0.0/10"
      ];
      "guest account" = "nobody";
      "map to guest" = "bad user";

      "load printers" = "no";
    };

    settings = {
      StrykeForce = {
        path = "/mnt/tank/share/strykeforce";
        public = "yes";
        writeable = "yes";
        "guest ok" = "yes";
      };
    };
  };

}
