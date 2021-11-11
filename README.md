# nixos-configs

NixOS Configs for Homelab

## NixOS

```sh
$ sudo ./deploy [host|all] command
```

_or, for local machine..._

```sh
$ sudo nixos-rebuild switch --flake .
```

## macOS

```sh
$ ln -s flake.nix ~/.config/nixpkgs
$ home-manager switch
```
