{
  flake,
  inputs,
  pkgs,
  ...
}:
let
  mediaUser = "media";
  mediaGroup = "media";
  sabnzbdDataDir = "/var/lib/sabnzbd";

  pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
    config.allowUnfree = true;
    config.permittedInsecurePackages = [
      "aspnetcore-runtime-wrapped-6.0.36"
      "aspnetcore-runtime-6.0.36"
      "dotnet-sdk-wrapped-6.0.428"
      "dotnet-sdk-6.0.428"
    ];
  };
in
{
  imports = [
    flake.modules.nixos.hardware-proxmox-lxc
    inputs.srvos.nixosModules.mixins-nginx
    flake.modules.nixos.j3ff-server
  ];

  networking.hostName = "ceres";
  nixpkgs.hostPlatform = "x86_64-linux";

  # sonarr

  services.sonarr = {
    enable = true;
    package = pkgsUnstable.sonarr;
    user = mediaUser;
    group = mediaGroup;
  };

  # radarr

  services.radarr = {
    enable = true;
    package = pkgsUnstable.radarr;
    user = mediaUser;
    group = mediaGroup;
  };

  # sabnzbd

  systemd.tmpfiles.rules = [
    "d '${sabnzbdDataDir}' 0700 ${mediaUser} ${mediaGroup} - -"
  ];

  services.sabnzbd = {
    enable = true;
    package = pkgsUnstable.sabnzbd;
    user = mediaUser;
    group = mediaGroup;
  };

  # nginx
  services.nginx.virtualHosts = {
    "sonarr.j3ff.io" = {
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:8989";
        };
      };
    };

    "radarr.j3ff.io" = {
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:7878";
        };
      };
    };

    "sabnzbd.j3ff.io" = {
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:8080";
        };
      };
    };
  };

  system.stateVersion = "23.11";
}
