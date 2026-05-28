{ pkgs, perSystem }:
pkgs.mkShell {

  packages = [
    perSystem.agenix.agenix
    perSystem.deploy-rs.deploy-rs
    pkgs.nixfmt
    pkgs.nil
  ];

  env = { };

  shellHook = "";
}
