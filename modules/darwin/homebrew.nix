{ ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      upgrade = true;
      autoUpdate = true;
    };

    taps = [
      "d12frosted/emacs-plus"
      "borkdude/brew"
      "avencera/tap"
    ];

    brews =
      let
        datalevin = [
          "libomp"
          "llvm"
        ];
      in
      [
        "avencera/tap/rustywind"
        "borkdude/brew/babashka"
        "borkdude/brew/clj-kondo"
        "clojure"
        "clojure-lsp"
        "emacs-plus"
        "neovim"
        "uv"
      ]
      ++ datalevin;

    casks = [
      "1password"
      "1password-cli"
      "calibre"
      "carbon-copy-cloner"
      "dash"
      "discord"
      "firefox"
      "iterm2"
      # "jetbrains-toolbox"
      "omnigraffle"
      "postgres-unofficial"
      "postico"
      "qlmarkdown"
      "slack"
      "spotify"
      "tableplus"
      "thetimemachinemechanic"
      "transmit"
      "utm"
      "visual-studio-code"
      "zotero"
    ];

    masApps = {
      "Icon Slate" = 439697913;
      "Infuse 7" = 1136220934;
      "Paprika Recipe Manager 3" = 1303222628;
      "Pcalc" = 403504866;
      "Reeder 5" = 1529448980;
      "Tailscale" = 1475387142;
    };
  };
}
