{ buildVimPlugin, fetchFromGitHub }:

{
  # nix run nixpkgs#nix-prefetch-github -- polarmutex beancount.nvim
  beancount-nvim = buildVimPlugin {
    pname = "beancount-nvim";
    version = "0.1.0";
    src = fetchFromGitHub {
      owner = "polarmutex";
      repo = "beancount.nvim";
      rev = "9ae9d37c23ac8ff054a61025aae6b70739ac7b8e";
      sha256 = "sha256-kV3NvBsgSOT/z/RFt4299wh0MplwiXRd+vgK8MxgvXM=";
    };
  };
}
