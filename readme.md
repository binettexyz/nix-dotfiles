# Nixos configuration

```shell
doas ln -sr ~/.nixos/machines/$HOST/configuration.nix  configuration.nix
doas nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
doas nix-channel --add https://nixos.org/channels/nixos-21.05 nixos
doas nix-channel --update
doas nixos-rebuild switch --upgrade
```
