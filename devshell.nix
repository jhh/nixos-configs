{ pkgs, perSystem }:
pkgs.mkShell {

  packages = [
    perSystem.agenix.agenix
    pkgs.nixfmt-rfc-style
  ];

  env = { };

  shellHook = "";
}
