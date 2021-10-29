{ config, lib, pkgs, ... }:
{
  options = {
    j3ff.man.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = "enable manual pages";
    };
  };

  config = lib.mkIf config.j3ff.man.enable {
    documentation = {
      man = {
        enable = true;
        generateCaches = true;
      };
      dev.enable = true;
    };
  };
}
