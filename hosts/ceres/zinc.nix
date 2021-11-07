{ flakes, config, lib, pkgs, ... }:
let
  zinc = flakes.zinc.defaultPackage.x86_64-linux;
in
{
  systemd.services.zinc = {
    description = "Zrepl local console";
    documentation = [ "https://github.com/jhh/zinc" ];
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.zrepl ];
    environment = {
      FLASK_APP = "zinc";
      FLASK_ENV = "production";
    };
    serviceConfig = {
      ExecStart = "${zinc}/bin/flask run --host=0.0.0.0";
      Restart = "always";
    };
  };
}
