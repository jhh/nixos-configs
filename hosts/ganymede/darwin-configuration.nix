{
  flake,
  pkgs,
  ...
}:

{
  imports = [
    flake.modules.darwin.default
    flake.modules.darwin.homebrew
    flake.modules.darwin.home-manager-jeff
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  environment.shells = [ pkgs.fish ];

}
