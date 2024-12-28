{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    j3ff.man.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = false;
      description = "enable manual pages";
    };
  };

  config =
    let
      cfg = config.j3ff.man;
    in
    lib.mkIf cfg.enable {
      documentation = {
        man = {
          enable = true;
          generateCaches = true;
        };
        dev.enable = true;
      };
    };
}
