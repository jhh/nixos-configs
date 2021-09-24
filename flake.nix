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
            options = "--delete-older-than 6w --max-freed 256M";
          };
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

    };
  };
}
