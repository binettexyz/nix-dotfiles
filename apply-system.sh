#!/run/current-system/sw/bin/sh
pushd ~/.nixos
sudo nixos-install -I nixos-config=./system/configuration.nix --root /mnt
popd
