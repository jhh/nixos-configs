{
  config,
  lib,
  pkgs,
  ...
}:
{
  age.secrets.pbs_cloyster = {
    file = ../../secrets/pbs_cloyster.age;
  };

  environment.etc.".pxarexclude".text = ''
    **/*
    !group
    !machine-id
    !passwd
    !subgid
  '';

  systemd.services.pbs-backup = {
    startAt = "daily";

    serviceConfig = {
      EnvironmentFile = config.age.secrets.pbs_cloyster.path;
      ExecStart = ''
        ${lib.getExe pkgs.proxmox-backup-client} backup \
          nixos.pxar:/var/lib/nixos \
          etc.pxar:/etc \
          --ns daily
      '';
    };
  };

}
