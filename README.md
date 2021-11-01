# nixos-configs
NixOS Configs for Homelab

## NixOS

```sh
$ sudo ./deploy [host|all] command
```

*or, for local machine...*


```sh
$ sudo nixos-rebuild switch --flake .
```

## macOS

```sh
$ nix build .#homeManagerConfigurations.europa.activationPackage
$ ./result/activate
```
