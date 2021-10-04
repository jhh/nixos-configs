{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { nixpkgs, ... }: {
    colmena = {
      meta = {
        inherit nixpkgs;
      };

      defaults = { pkgs, ... }: {
        boot.loader.systemd-boot.configurationLimit = 10;
        environment.systemPackages = with pkgs; [ vim wget curl ];
        networking.domain = "lan.j3ff.io";

        security.sudo.wheelNeedsPassword = false;
        i18n.defaultLocale = "en_US.UTF-8";
        time.timeZone = "America/Detroit";

        services.openssh = {
          enable = true;
          permitRootLogin = "prohibit-password";
        };

        nixpkgs.config.allowUnfree = true;
        nix = {
          autoOptimiseStore = true;
          gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 30d --max-freed 256M";
          };
          package = pkgs.nixUnstable;
          extraOptions = ''
            experimental-features = nix-command flakes
          '';
        };

      };

      eris = { name, nodes, ... }: {
        networking.hostName = name;

        imports = [
          <home-manager/nixos>
          ./common/services
          ./common/users
          ./hosts/eris/configuration.nix
          ./hosts/eris/grafana.nix
          ./hosts/eris/prometheus.nix
        ];

        j3ff = {
          mail.enable = true;
          smartd.enable = true;
          tailscale.enable = true;
          ups.enable = true;
          zfs = {
            enable = true;
            enableTrim = true;
          };
          zrepl.enable = true;
        };

        documentation.man.generateCaches = true;

        home-manager.useGlobalPkgs = true;
        home-manager.users.jeff = { pkgs, ... }: { imports = [ ./home ]; };

        deployment = {
          allowLocalDeployment = true;
          targetHost = null;
        };
      };

      luna = { pkgs, name, nodes, ... }: {
        networking.hostName = name;

        imports = [
          <home-manager/nixos>
          ./hosts/luna/configuration.nix
          ./hosts/luna/nfs.nix
          ./hosts/luna/plex.nix
          ./hosts/luna/samba.nix
          ./hosts/luna/zrepl.nix
          ./common/services
          ./common/users
        ];

        j3ff = {
          mail.enable = true;
          smartd.enable = true;
          tailscale.enable = true;
          ups.enable = true;
          zfs = {
            enable = true;
            enableTrim = false;
          };
          zrepl.enable = false; # zrepl server
        };

        home-manager.useGlobalPkgs = true;
        home-manager.users.jeff = { pkgs, ... }: { imports = [ ./home ]; };

        deployment = {
          allowLocalDeployment = false;
          targetHost = "192.168.1.7";
        };

        # Prometheus
        services.prometheus = {
          exporters = {
            node = {
              enable = true;
              enabledCollectors = [ "systemd" "processes" "nfs" "nfsd" ];
              port = 9002;
            };
          };
        };


      };

      phobos = { pkgs, name, nodes, ... }: {
        networking.hostName = name;

        imports = [
          <home-manager/nixos>
          ./hosts/phobos/configuration.nix
          ./hosts/phobos/zrepl.nix
          ./common/services
          ./common/users
        ];

        j3ff = {
          mail.enable = true;
          smartd.enable = true;
          tailscale.enable = true;
          ups.enable = false;
          zfs = {
            enable = true;
            enableTrim = false;
          };
          zrepl.enable = false; # zrepl server
        };

        home-manager.useGlobalPkgs = true;
        home-manager.users.jeff = { pkgs, ... }: { imports = [ ./home ]; };

        deployment = {
          allowLocalDeployment = false;
          targetHost = "100.64.244.48";
        };

        # Prometheus
        services.prometheus = {
          exporters = {
            node = {
              enable = true;
              enabledCollectors = [ "systemd" "processes" ];
              port = 9002;
            };
          };
        };


      };

      ceres = { name, nodes, ... }: {
        networking.hostName = name;

        imports = [
          <home-manager/nixos>
          ./common/services
          ./common/users
          ./hosts/ceres/configuration.nix
        ];

        j3ff = {
          virtualization.enable = true;
          mail.enable = true;
          smartd.enable = true;
          tailscale.enable = true;
          ups.enable = true;
          zfs = {
            enable = true;
            enableTrim = true;
          };
          zrepl.enable = true;
        };


        home-manager.useGlobalPkgs = true;
        home-manager.users.jeff = { pkgs, ... }: { imports = [ ./home ]; };

        deployment = {
          allowLocalDeployment = false;
          targetHost = "192.168.1.9";
        };

        # Prometheus
        services.prometheus = {
          exporters = {
            node = {
              enable = true;
              enabledCollectors = [ "systemd" "processes" ];
              port = 9002;
            };
          };
        };
      };
    };
  };
}
