# NixOS Installation Guide

## Installation
The partitioning setup is based on these projects:
- [NixOS: tmpfs as root](https://elis.nu/blog/2020/05/nixos-tmpfs-as-root/)
- [Impermanence](https://github.com/nix-community/impermanence)

### Partitioning
Here we're gonna mount `/` as tmpfs so every time the computer start, the root directory will be wipe.  
Only the mounted and impermanence directory gonna stay intact.

```sh
dev=/dev/sdx
  # create partitions
parted    ${dev} mklabel gpt
parted -s ${dev} mkpart primary fat32 1MiB 513MiB
parted -s ${dev} mkpart primary ext4 513MiB 100%

  # Create two logical volumes
pvcreate -ff ${dev}2
vgcreate vg ${dev}2

lvcreate -L 100G vg -n nix
lvcreate -l 100%FREE vg -n home

  # Format the partitions
mkfs.vfat -n boot ${dev}1
mkfs.ext4 -L nix /dev/vg/nix
mkswap -L swap /dev/vg/swap
swapon /dev/vg/swap

  # Mounting the partitions
mount -t tmpfs none /mnt
mkdir -p /mnt/{boot,home,nix,etc/{nixos,ssh},var/{lib,log},srv,tmp}
mount ${dev}1 /mnt/boot
mount /dev/vg/nix /mnt/nix
mkdir -p /mnt/nix/persist/{home,nix,etc/{nixos,ssh},var/{lib,log},root,srv}

mount -o bind /mnt/nix/persist/etc/nixos /mnt/etc/nixos
mount -o bind /mnt/nix/persist/var/log /mnt/var/log
```

### Building System
#### Standard Computer
On a standard computer, it's pretty much straightfoward:

```sh
$ git clone http://github.com/binettexyz/nix-dotfiles /etc/nixos/.
$ cd /etc/nixos  
  # Edit config to fit your system
$ vim hosts/<host>/hardware.nix
$ nixos-install --flake .#<host> --no-root-passwd
```

#### Steamdeck
On a gaming handheld device, at least the steamdeck, there's an extra step:

```sh
$ git clone https://github.com/binettexyz/nix-dotfiles /etc/nixos/.
$ cd /etc/nixos
  # Edit config to fit your system
$ vim hosts/<host>/hardware.nix
  # Here, you want to mount /tmp where there's more space (like in your home directory)
$ mount -o bind /tmp <another /tmp directory>
$ nixos-install --flake .#<host> --no-root-passwd
```

- The reason we mount /tmp elsewhere is, if you build the config locally, you'll have a lack of space error when building the kernel. \\
- If you're using grub instead of systemd-boot, make sure to set =canTouchEfiVariables = false= and =efiInstallAsRemovable = true;= or else there wont be any boot option in bios. \\
- Since the steamdeck isn't powerfull, compiling the kernel will take a lot of time, you should build the system remotely and install it locally.
