{ flakes, config, lib, pkgs, ... }:
{
  systemd.services.zinc = {
    description = "Zrepl local console";
    documentation = [ "https://github.com/jhh/zinc" ];
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      "FLASK_APP" = "zinc";
      "FLASK_ENV" = "production";
    };
    script = ''
      ${flakes.zinc.defaultPackage.x86_64-linux}/bin/flask run
    '';
  };
}
