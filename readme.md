# NixOS setup

## Partitioning/Setup
The partitioning setup will be based on these projects:

- [NixOS ❄: tmpfs as root](https://elis.nu/blog/2020/05/nixos-tmpfs-as-root/)
- [Impermanence](https://github.com/nix-community/impermanence)


``` sh
dev=/dev/sdb # replace with your device
parted ${dev} -- mklabel msdos
parted ${dev} -- mkpart primary ext4 1M 512M
parted ${dev} -- set 1 boot on
parted ${dev} -- mkpart primary ext4 512MiB 100%
mkfs.ext4 -L boot ${dev}1
mkfs.ext4 -L nix ${dev}2

```
