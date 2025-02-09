{
  description = "Configs for j3ff.io homelab";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    blueprint.url = "github:numtide/blueprint";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager?ref=release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    puka.url = "github:jhh/puka";
    puka.inputs.nixpkgs.follows = "nixpkgs";

    srvos.url = "github:nix-community/srvos";
    srvos.inputs.nixpkgs.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:Lnl7/nix-darwin?ref=nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nixos-vscode-server.url = "github:nix-community/nixos-vscode-server";
    nixos-vscode-server.inputs.nixpkgs.follows = "nixpkgs";

    upkeep.url = "github:jhh/upkeep";
    upkeep.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    inputs.blueprint { inherit inputs; }
    // {
      deploy.nodes =
        let
          inherit (inputs.nixpkgs) lib;
          nodeFor =
            hostname:
            {
              sshUser ? "root",
              fastConnection ? true,
            }:
            {
              ${hostname} = {
                inherit hostname fastConnection sshUser;
                profiles.system = {
                  user = "root";
                  path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations.${hostname};
                };
              };
            };
        in
        lib.concatMapAttrs nodeFor {
          ceres = { };
          eris = { };
          luna = { };
          pluto = { };
          phobos = {
            fastConnection = false;
          };
          styx = { };
          vesta = { };
        };

      checks = builtins.mapAttrs (
        system: deployLib: deployLib.deployChecks inputs.self.deploy
      ) inputs.deploy-rs.lib;
    };
}
