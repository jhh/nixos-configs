{
  description = "NixOS configurations for j3ff.io";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    deploy-rs.url = "github:serokell/deploy-rs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
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
  };

  outputs = { self, agenix, nixpkgs, home-manager, darwin, deploy-rs, deadeye, nt-server, ... } @ flakes:
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

      darwinConfigurations."Europa" = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          ./hosts/europa
          home-manager.darwinModules.home-manager
          ({ config, ... }: {
            home-manager.useGlobalPkgs = true;
            home-manager.extraSpecialArgs = { inherit flakes; };
            home-manager.users.jeff = {
              imports = [ ./common/home-manager ];
            };
          })
        ];
      };

      nixosConfigurations = {
        nixos-01 = mkSystem [ ./hosts/nixos-01 ];
        phobos = mkSystem [ ./hosts/phobos ];

        luna = mkSystem [
          ./hosts/luna
          nt-server.nixosModules.default
          ({ config, ... }: {
            j3ff.networkTables.enable = true;
          })
        ];

        vesta = mkSystem [
          ./hosts/vesta
          deadeye.nixosModules.default
          ({ config, ... }: {
            deadeye = {
              web.enable = true;
              admin.enable = true;
              daemon = {
                enable = true;
                unitId = "V";
                pipeline0 = "deadeye::UprightRectPipeline";
                pipeline1 = "deadeye::MinAreaRectPipeline";
                pipeline2 = "deadeye::TargetListPipeline";
                streamAddress = "${(builtins.head config.networking.interfaces.br0.ipv4.addresses).address}";
              };
              ntServerAddress = "192.168.1.30";
            };

          })
        ];
      };


      deploy.nodes = {
        luna = {
          hostname = "192.168.1.7";
          sshUser = "root";
          fastConnection = true;

          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.luna;
          };
        };

        nixos-01 = {
          hostname = "192.168.1.228";
          sshUser = "root";
          fastConnection = true;

          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.nixos-01;
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
          hostname = "192.168.1.45";
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
