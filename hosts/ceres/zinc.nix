{ flakes, config, lib, pkgs, ... }:
let
  zinc = flakes.zinc.defaultPackage.x86_64-linux;
in
{
  users.users.zinc = {
    isSystemUser = true;
    shell = null;
    description = "Zinc Service";
    group = "zinc";
  };
  users.groups.zinc = { };

  security.sudo.extraRules = [
    {
      users = [ "zinc" ];
      commands = [{
        command = "${pkgs.zrepl}/bin/zrepl status --mode=raw";
        options = [ "NOPASSWD" ];
      }];
    }
  ];

  systemd.services.zinc = {
    description = "Zrepl local console";
    documentation = [ "https://github.com/jhh/zinc" ];
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      FLASK_APP = "zinc";
      FLASK_ENV = "production";
      SUDO = "${config.security.wrapperDir}/sudo";
      ZREPL = "${pkgs.zrepl}/bin/zrepl";
    };
    serviceConfig = {
      User = "zinc";
      Group = "zinc";
      ExecStart = "${zinc}/bin/flask run --host=0.0.0.0";
      Restart = "always";

      # security hardening
      PrivateTmp = "true";
      ProtectSystem = "true";
      ProtectHome = "true";
    };
  };
}
