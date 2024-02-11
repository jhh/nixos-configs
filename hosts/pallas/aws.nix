{ config, pkgs, ... }:
{
  age.secrets.aws_credentials = {
    file = ../../secrets/aws_secret.age;
    path = "/root/.aws/credentials";
  };

  systemd.services.copy-aws-config =
    let
      config = (pkgs.formats.ini { }).generate "aws-config-root" {
        default = {
          region = "us-east-2";
          output = "json";
        };
      };
    in
    {
      enable = true;
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.coreutils}/bin/ln -sf ${config} /root/.aws/config";
      };
      wantedBy = [ "multi-user.target" ];
    };
}
