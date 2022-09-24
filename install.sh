#!/bin/sh
set -e

# Replace with your device
dev=$1
lvm=lvm

crypt=off
home=off

  # Cloning NixOS Config
git clone https://github.com/binettexyz/nix-dotfiles

  ### Partitioning ###

  # create partitions
parted    ${dev} mklabel gpt
parted -s ${dev} mkpart primary fat32 1MiB 513MiB
parted -s ${dev} mkpart primary ext4 513MiB 100%
parted -s ${dev} set 1 boot on
parted -s ${dev} name 1 boot
parted -s ${dev} name 1 nix

if [ $crypt == "on" ]; then
      # Setup the encrypted LUKS partition and open it:
    cryptsetup luksFormat ${dev}2
    cryptsetup open --type luks ${dev}2 $lvm
fi

  # Create two logical volumes
pvcreate -ff ${dev}2
vgcreate lvm ${dev}2

lvcreate -L 16G $lvm -n swap
lvcreate -l 100%FREE $lvm -n nix

  # Format the partitions
mkfs.vfat -n boot ${dev}1
mkfs.ext4 -L nix /dev/$lvm/nix
mkswap -L swap /dev/$lvm/swap
swapon /dev/$lvm/swap


  ### Installing NixOS ###

  # Mounts
mount -t tmpfs none /mnt
mkdir -p /mnt/{boot,home,nix,etc/{nixos,ssh},var/{lib,log},srv,tmp}
mount ${dev}1 /mnt/boot
mount /dev/$lvm/nix /mnt/nix
  # Uncomment if it's a fresh install
mkdir -p /mnt/nix/persist/{home,media,mounts,nix,etc/{nixos,ssh},var/{lib,log},root,srv}

mount -o bind /mnt/nix/persist/etc/nixos /mnt/etc/nixos
mount -o bind /mnt/nix/persist/var/log /mnt/var/log

  # Copying NixOS Configs where it's supposed to be
cp -R /home/nixos/nix-dotfiles/ /mnt/nix/persist/etc/nixos/

  # Set tmpfile into /mnt to prevent "not enough space" error
export TMPDIR=/mnt/tmp

nixos-install --flake /mnt/etc/nixos#.
