{
  description = "NixOS configurations for j3ff.io";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-21.11";

    home-manager = {
      url = "github:nix-community/home-manager/master";
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

    zinc.url = "github:jhh/zinc";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ flakes:
    let
      mkHost = name: pkgs: hm: pkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          (./hosts + "/${name}")
          ./common
          hm.nixosModules.home-manager
          ({
            system.configurationRevision =
              if self ? rev
              then self.rev
              else "DIRTY";
          })
        ];
        specialArgs = { inherit flakes; };
      };
    in
    {
      nixosConfigurations = {
        ceres = mkHost "ceres" nixpkgs home-manager;
        eris = mkHost "eris" nixpkgs home-manager;
        luna = mkHost "luna" nixpkgs home-manager;
        pallas = mkHost "pallas" nixpkgs home-manager;
        phobos = mkHost "phobos" nixpkgs home-manager;
        vesta = mkHost "vesta" nixpkgs home-manager;
      };

      homeConfigurations = {
        jeff = home-manager.lib.homeManagerConfiguration {
          configuration = ./home;
          system = "x86_64-darwin";
          homeDirectory = "/Users/jeff";
          username = "jeff";
          extraSpecialArgs = { inherit flakes; };
        };
      };
    };
}
