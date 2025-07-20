{ pkgs, ... }:
{
  imports = [
    ./bat
    ./fish
    ./git
    ./nvim # no-op unless isLinux
    ./zed.nix
  ];

  home.sessionVariables = {
    MANWIDTH = 88;
  };

  home.packages = with pkgs; [
    bottom
    du-dust
    duf
    fd
    fzf
    glow
    gh
    lazygit
    prettyping
    ripgrep
    stow
  ];

  programs = {
    awscli.enable = true;

    bat.enable = true;

    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };

    eza = {
      enable = true;
      enableFishIntegration = true;
      icons = "never";
    };

    gpg = {
      enable = true;
      settings = {
        keyserver = "hkps://keys.openpgp.org";
      };
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

  };

  home.stateVersion = "24.11";
}
