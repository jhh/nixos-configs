{ pkgs, perSystem }:
pkgs.mkShell {

  packages = [
    perSystem.agenix.agenix
    pkgs.nixfmt-rfc-style
    pkgs.nil
  ];

  env = { };

  shellHook = "";
}
