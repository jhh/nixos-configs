{ flake, ... }:
{
  imports = [
    flake.modules.darwin.default
    flake.modules.darwin.homebrew
    flake.modules.darwin.home-manager-jeff
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 4;
}
