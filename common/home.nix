{ config, pkgs, flakes, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit flakes; };
    users = {

      jeff = {
        imports = [
          ../home
        ];
        j3ff.gui = config.services.xserver.enable;
      };

      root = {
        imports = [
          ../home/nvim
        ];
        home.username = "root";
        home.homeDirectory = "/root";
        home.sessionVariables = {
          EDITOR = "vim";
          MANWIDTH = 100;
        };
        home.packages = with pkgs; [
          fd
          git
          nix-diff
          ripgrep
        ];
        programs = {
          bash.enable = true;
          bat.enable = true;
          exa = {
            enable = true;
            enableAliases = true;
          };
        };
      };
    };
  };
}
