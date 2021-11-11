#!/run/current-system/sw/bin/sh
pushd ~/.dotfiles
sudo nixos-install -I nixos-config=./system/configuration.nix --root /mnt
popd
