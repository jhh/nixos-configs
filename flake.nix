{
  description = "NixOS configurations for j3ff.io";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    deploy-rs.url = "github:serokell/deploy-rs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    fish-nix-env = {
      url = "github:lilyball/nix-env.fish";
      flake = false;
    };

    deadeye = {
      url = "github:strykeforce/deadeye";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nt-server = {
      url = "github:jhh/nt-server-docker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dyndns = {
      url = "github:jhh/dyndns";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    puka = {
      url = "github:jhh/puka";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    strykeforce.url = "github:strykeforce/strykeforce.org/v4.0.0";
  };

  outputs =
    { self
    , agenix
    , darwin
    , deadeye
    , deploy-rs
    , dyndns
    , home-manager
    , home-manager-unstable
    , nixpkgs
    , nixpkgs-unstable
    , nt-server
    , puka
    , strykeforce
    , ...
    } @ flakes:
    let
      pkgs = nixpkgs.legacyPackages."x86_64-linux";

      mkSystem =
        { packages ? nixpkgs
        , homeManager ? home-manager
        , extraModules
        }:
        packages.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            # ({ config, pkgs, ... }: {  packages.overlays = [ strykeforce.overlay ]; })
            agenix.nixosModule
            home-manager.nixosModules.home-manager
            ({ config, ... }: {
              services.getty.greetingLine =
                "<<< Welcome to NixOS ${config.system.nixos.label} @ ${self.sourceInfo.rev} - \\l >>>";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit flakes; };

              system.configurationRevision = self.sourceInfo.rev;
              system.activationScripts.diff = ''
                if [[ -e /run/current-system ]]; then
                  ${pkgs.nix}/bin/nix store diff-closures /run/current-system "$systemConfig"
                fi
              '';
            })
            ./common
            deadeye.nixosModules.default
            nt-server.nixosModules.default
            dyndns.nixosModules.default
            puka.nixosModules.default
            strykeforce.nixosModule
          ] ++ extraModules;
        };
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = [
          deploy-rs.packages.x86_64-linux.deploy-rs
          agenix.packages.x86_64-linux.agenix
        ];
      };

      darwinConfigurations."Ganymede" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/ganymede
          home-manager-unstable.darwinModules.home-manager
          ({ config, ... }: {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.config.allowBroken = false;
            home-manager.useGlobalPkgs = true;
            home-manager.extraSpecialArgs = { inherit flakes; };
            home-manager.users.jeff = {
              imports = [ ./common/home-manager ];
            };
          })
        ];
      };

      nixosConfigurations = {
        eris = mkSystem { extraModules = [ ./hosts/eris ]; };
        luna = mkSystem { extraModules = [ ./hosts/luna ]; };

        pallas = mkSystem {
          extraModules = [
            ./hosts/pallas
            ({ config, pkgs, ... }: {
              age.secrets.stryker_website_secrets = {
                file = common/modules/secrets/strykeforce_website_secrets.age;
              };
              strykeforce.services.website = {
                enable = true;
                settingsModule = "website.settings.production";
              };
            })
          ];
        };

        phobos = mkSystem { extraModules = [ ./hosts/phobos ]; };
        vesta = mkSystem { extraModules = [ ./hosts/vesta ]; };
        ceres = mkSystem
          {
            packages = nixpkgs-unstable;
            homeManager = home-manager-unstable;
            extraModules = [ ./hosts/ceres ];
          };
      };


      deploy.nodes = {
        ceres = {
          hostname = "10.1.0.44";
          sshUser = "root";
          fastConnection = true;

          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.ceres;
          };
        };

        eris = {
          hostname = "10.1.0.46";
          sshUser = "root";
          fastConnection = true;

          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.eris;
          };
        };

        luna = {
          hostname = "10.1.0.7";
          sshUser = "root";
          fastConnection = true;

          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.luna;
          };
        };

        pallas = {
          hostname = "10.1.0.47";
          sshUser = "root";
          fastConnection = true;

          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.pallas;
          };
        };

        phobos = {
          hostname = "100.64.244.48";
          sshUser = "root";

          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.phobos;
          };
        };


        vesta = {
          hostname = "10.1.0.45";
          sshUser = "root";
          fastConnection = true;

          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.vesta;
          };
        };
      };

      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy)
        deploy-rs.lib;
    };
}
