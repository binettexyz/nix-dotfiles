# Binette's nixos config

## installation
clone this repo as follow:
```
nix-shell -p yadm -p git -p gnupg1orig
yadm clone https://github.com/Binetto/.nixos.git -w /etc/nixos --yadm-dir /etc/nixos/.yadm/config --yadm-data /etc/nixos/.yadm/data
exit
```
edit config files and modules as you like and run `install-system.sh` script.
