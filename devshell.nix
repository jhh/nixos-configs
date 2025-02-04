{ pkgs, perSystem }:
pkgs.mkShell {

  packages = [
    perSystem.agenix.agenix
  ];

  env = { };

  shellHook = ''

  '';
}
