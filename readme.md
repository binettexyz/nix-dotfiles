# Nixos configuration

## installation
Clone this repo as follow:
```
nix-shell -p yadm -p git -p gnupg1orig
yadm clone https://github.com/Binetto/.nixos.git -w /etc/nixos --yadm-dir /etc/nixos/.yadm/config --yadm-data /etc/nixos/.yadm/data
exit
```
ps: if your hostname isn't the same as in the files name (e.g: configuration.nix##hostname.`yourHostName`), symlink won't be created.

Edit config files and modules as you like and run `install-system.sh` script.
