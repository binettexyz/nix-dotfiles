#!/run/current-system/sw/bin/sh

nix-shell -p yadm -p git
yadm clone https://github.com/Binetto/.nixos.git -w /etc/nixos --yadm-dir /etc/nixos/.yadm/config --yadm-data /etc/nixos/.yadm/data
yadm --yadm-dir /etc/nixos/.yadm/config --yadm-data /etc/nixos/.yadm/data alt
exit

pushd ~/.nixos
sudo nixos-install -I nixos-config=./system/configuration.nix --root /mnt
popd
