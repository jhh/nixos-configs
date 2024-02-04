# nixos-configs

NixOS Configs for Homelab

## NixOS

Uses [deploy-rs](https://github.com/serokell/deploy-rs) to deploy to multiple hosts.

### All hosts

```sh
$ deploy
```

### Specific hosts

```sh
$ deploy .#host
```

_or, optionally for local machine..._

```sh
$ sudo nixos-rebuild switch --flake .
```

## macOS

```sh
$ darwin-rebuild switch --flake .
```
