{
  description = "NixOS configurations for j3ff.io";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    deploy-rs.url = "github:serokell/deploy-rs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fish-colored-man = {
      url = "github:decors/fish-colored-man";
      flake = false;
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
  };

  outputs = { self, agenix, nixpkgs, home-manager, darwin, deploy-rs, deadeye, nt-server, dyndns, puka, ... } @ flakes:
    let
      pkgs = nixpkgs.legacyPackages."x86_64-linux";

      mkSystem = extraModules:
        nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            # ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-nut ]; })
            agenix.nixosModule
            home-manager.nixosModules.home-manager
            ({ config, ... }: {
              system.configurationRevision = self.sourceInfo.rev;
              services.getty.greetingLine =
                "<<< Welcome to NixOS ${config.system.nixos.label} @ ${self.sourceInfo.rev} - \\l >>>";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit flakes; };
            })
            ./common
            deadeye.nixosModules.default
            nt-server.nixosModules.default
            dyndns.nixosModules.default
            puka.nixosModules.default
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
          home-manager.darwinModules.home-manager
          ({ config, ... }: {
            nixpkgs.config.allowBroken = true;
            home-manager.useGlobalPkgs = true;
            home-manager.extraSpecialArgs = { inherit flakes; };
            home-manager.users.jeff = {
              imports = [ ./common/home-manager ];
            };
          })
        ];
      };

      nixosConfigurations = {
        # nixos-01 = mkSystem [ ./hosts/nixos-01 ];
        phobos = mkSystem [ ./hosts/phobos ];
        luna = mkSystem [ ./hosts/luna ];
        # ceres = mkSystem [ ./hosts/ceres ];

        eris = mkSystem [
          ./hosts/eris
          ({ config, ... }: {
            age.secrets.puka_secrets = {
              file = ./common/modules/secrets/puka_secrets.age;
            };
            j3ff.puka.enable = true;
          })
        ];

        vesta = mkSystem [
          ./hosts/vesta
          ({ config, ... }: {
            age.secrets.aws_secret = {
              file = ./common/modules/secrets/aws_secret.age;
            };
            j3ff.dyndns.enable = true;
          })
        ];
        # deadeye-h = mkSystem [ ./hosts/deadeye/deadeye-h.nix ];
        # deadeye-i = mkSystem [ ./hosts/deadeye/deadeye-i.nix ];
        # deadeye-j = mkSystem [ ./hosts/deadeye/deadeye-j.nix ];
        # deadeye-k = mkSystem [ ./hosts/deadeye/deadeye-k.nix ];
      };


      deploy.nodes = {
        # ceres = {
        #   hostname = "100.121.169.6";
        #   sshUser = "root";
        #   fastConnection = false;

        #   profiles.system = {
        #     user = "root";
        #     path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.ceres;
        #   };
        # };

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

        # nixos-01 = {
        #   hostname = "192.168.1.228";
        #   sshUser = "root";
        #   fastConnection = true;

        #   profiles.system = {
        #     user = "root";
        #     path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.nixos-01;
        #   };
        # };

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

        #   deadeye-h = {
        #     hostname = "100.95.246.14";
        #     sshUser = "root";
        #     fastConnection = false;

        #     profiles.system = {
        #       user = "root";
        #       path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.deadeye-h;
        #     };
        #   };

        #   deadeye-i = {
        #     hostname = "100.94.177.5";
        #     sshUser = "root";
        #     fastConnection = false;

        #     profiles.system = {
        #       user = "root";
        #       path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.deadeye-i;
        #     };
        #   };

        #   deadeye-j = {
        #     hostname = "100.99.227.108";
        #     sshUser = "root";
        #     fastConnection = false;

        #     profiles.system = {
        #       user = "root";
        #       path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.deadeye-j;
        #     };
        #   };

        #   deadeye-k = {
        #     hostname = "100.121.82.94";
        #     sshUser = "root";
        #     fastConnection = false;

        #     profiles.system = {
        #       user = "root";
        #       path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.deadeye-k;
        #     };
        #   };
      };

      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy)
        deploy-rs.lib;
    };
}
