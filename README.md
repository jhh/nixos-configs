# nixos-configs
NixOS Configs for Homelab

## Linux

```sh
$ sudo ./deploy [host|all] command
```

## Darwin

```sh
$ nix build .#homeManagerConfigurations.europa.activationPackage
$ ./result/activate
```
