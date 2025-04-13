{
  lib,
  pkgs,
  ...
}:
lib.mkIf pkgs.stdenv.isLinux {
  home.packages = [ pkgs.nil ];

  home.file = {
    ".config/zed/settings.json".text = builtins.toJSON {
      languages = {
        Nix = {
          language_servers = [
            "nil"
            "!nixd"
          ];
        };
      };
      lsp = {
        nil = {
          settings = {
            formatting = {
              command = [ (lib.getExe pkgs.nixfmt-rfc-style) ];
            };
          };
        };
      };
    };
  };
}
