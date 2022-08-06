#!/bin/sh
doas nix-channel --add "https://github.com/NixOS/nixpkgs/archive/master.tar.gz" nixos
doas nix-channel --add "https://github.com/nix-community/impermanence/archive/master.tar.gz" impermanence
nix-channel --add "https://github.com/nix-community/home-manager/archive/master.tar.gz" home-manager
nix-channel --update
