#!/bin/sh
doas nix-channel --add https://nixos.org/channels/nixos-21.11 nixos
nix-channel --add https://nixos.org/channels/nixos-21.11 nixos
nix-channel --add https://nixos.org/channels/nixos-21.11-small nixos-small
nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
nix-channel --add https://nixos.org/channels/nixos-unstable-small nixos-unstable-small
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
