{ pkgs, perSystem }:
pkgs.mkShell {

  packages = [
    perSystem.agenix.agenix
    perSystem.deploy-rs.deploy-rs
    pkgs.nixfmt-rfc-style
    pkgs.nil
  ];

  env = { };

  shellHook = "";
}
