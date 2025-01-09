{
  description = "NixOS configurations for j3ff.io";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    deploy-rs.url = "github:serokell/deploy-rs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # neovim-nightly-overlay = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };

    puka = {
      url = "github:jhh/puka";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    upkeep = {
      url = "github:jhh/upkeep";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    fava-yoyodyne = {
      url = "github:jhh/fava-yoyodyne";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    todo = {
      url = "git+https://gitea.j3ff.io/jeff/todo.git";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    strykeforce.url = "github:strykeforce/strykeforce.org";
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs =
    inputs@{
      self,
      agenix,
      darwin,
      deploy-rs,
      home-manager,
      home-manager-unstable,
      # neovim-nightly-overlay,
      nh,
      nixpkgs,
      nixpkgs-unstable,
      puka,
      strykeforce,
      fava-yoyodyne,
      vscode-server,
      todo,
      upkeep,
      ...
    }:
    let
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      pkgs-darwin = nixpkgs.legacyPackages."aarch64-darwin";

      # overlays = [
      #   neovim-nightly-overlay.overlays.default
      # ];

      mkSystem =
        {
          packages ? nixpkgs,
          homeManager ? home-manager,
          extraModules,
        }:
        packages.lib.nixosSystem {
          system = "x86_64-linux";
          # specialArgs.strykeforce = strykeforce;
          specialArgs = { inherit vscode-server strykeforce; };
          modules = [
            agenix.nixosModules.default
            homeManager.nixosModules.home-manager
            (
              { config, ... }:
              {
                environment.systemPackages = [
                  nh.packages.x86_64-linux.nh
                ];
                services.getty.greetingLine = "<<< Welcome to NixOS ${config.system.nixos.label} @ ${self.sourceInfo.rev} - \\l >>>";
                services.getty.autologinUser = packages.lib.mkDefault "root";
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = { inherit inputs; };

                system.configurationRevision = self.sourceInfo.rev;
              }
            )
            ./common
            puka.nixosModules.default
            strykeforce.nixosModules.default
            fava-yoyodyne.nixosModules.default
            todo.nixosModules.default
            upkeep.nixosModules.default
          ] ++ extraModules;
        };
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = [
          deploy-rs.packages.x86_64-linux.deploy-rs
          agenix.packages.x86_64-linux.agenix
          pkgs.nixfmt-rfc-style
        ];
      };

      devShells.aarch64-darwin.default = pkgs-darwin.mkShell {
        packages = [
          agenix.packages.aarch64-darwin.agenix
          pkgs-darwin.nixfmt-rfc-style
        ];
      };

      darwinConfigurations."Ganymede" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/ganymede
          home-manager-unstable.darwinModules.home-manager
          (
            { config, ... }:
            {
              environment.systemPackages = [
                nh.packages.aarch64-darwin.nh
              ];
              nixpkgs.config.allowUnfree = true;
              nixpkgs.config.allowBroken = false;
              home-manager.useGlobalPkgs = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.jeff = {
                imports = [
                  ./common/home-manager
                  (
                    { ... }:
                    {
                      j3ff.gui.ghostty.enable = true;
                    }
                  )
                ];
              };
            }
          )
        ];
      };

      nixosConfigurations = {
        eris = mkSystem { extraModules = [ ./hosts/eris ]; };
        luna = mkSystem { extraModules = [ ./hosts/luna ]; };
        pallas = mkSystem { extraModules = [ ./hosts/pallas ]; };
        phobos = mkSystem { extraModules = [ ./hosts/phobos ]; };
        styx = mkSystem { extraModules = [ ./hosts/styx ]; };
        titan = mkSystem { extraModules = [ ./hosts/titan ]; };
        vesta = mkSystem { extraModules = [ ./hosts/vesta ]; };

        ceres = mkSystem {
          packages = nixpkgs-unstable;
          homeManager = home-manager-unstable;
          extraModules = [ ./hosts/ceres ];
        };

      };

      deploy.nodes =
        let
          sshUser = "root";
          fastConnection = true;

          systemFor = host: {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.${host};
          };
        in
        {
          ceres = {
            hostname = "10.1.0.44";
            inherit sshUser fastConnection;
            profiles.system = systemFor "ceres";
          };

          eris = {
            hostname = "10.1.0.46";
            inherit sshUser fastConnection;
            profiles.system = systemFor "eris";
          };

          luna = {
            hostname = "10.1.0.7";
            inherit sshUser fastConnection;
            profiles.system = systemFor "luna";
          };

          styx = {
            hostname = "10.1.0.49";
            inherit sshUser fastConnection;
            profiles.system = systemFor "styx";
          };

          # deploy from strykeforce.org repo
          # pallas = {
          #   hostname = "10.1.0.47";
          #   inherit sshUser fastConnection;
          #   profiles.system = systemFor "pallas";
          # };

          phobos = {
            hostname = "100.64.244.48";
            inherit sshUser;
            profiles.system = systemFor "phobos";
          };

          vesta = {
            hostname = "10.1.0.45";
            inherit sshUser fastConnection;
            profiles.system = systemFor "vesta";
          };
        };

      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
