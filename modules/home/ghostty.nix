{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.j3ff.gui.ghostty;
in
{
  options = {
    j3ff.gui.ghostty = {
      enable = mkEnableOption "ghostty configuration";

      font = mkOption {
        type = types.str;
        default = "MonoLisa";
        description = "ghostty font";
      };

      theme = mkOption {
        type = types.str;
        default = "catppuccin-mocha";
        description = "ghostty theme";
      };
    };
  };

  config = mkIf (cfg.enable && pkgs.stdenv.isDarwin) {

    home.file."Library/Application Support/com.mitchellh.ghostty/config" = {
      text = builtins.concatStringsSep "\n" [
        "font-family = ${cfg.font} Regular"
        "font-family-bold = ${cfg.font} Bold"
        "font-family-italic = ${cfg.font} Regular Italic"
        "font-family-bold-italic = ${cfg.font} Bold Italic"
        "font-feature = calt"
        "theme = ${cfg.theme}"
        "keybind = global:opt+grave_accent=toggle_quick_terminal"

      ];
    };
  };

}
