{ flake, ... }:
{
  imports = [
    flake.modules.darwin.default
    flake.modules.darwin.homebrew
    flake.modules.darwin.home-manager-jeff
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.primaryUser = "jeff";

  nix.linux-builder = {
    enable = true;
    ephemeral = true;
    maxJobs = 4;
    config = {
      virtualisation = {
        darwin-builder = {
          diskSize = 40 * 1024;
          memorySize = 8 * 1024;
        };
        cores = 6;
      };
    };
  };

  ids.gids.nixbld = 350;
  system.stateVersion = 4;
}
