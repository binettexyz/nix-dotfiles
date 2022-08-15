#!/bin/sh
set -e

# Replace with your device
DISK=/dev/sdx
SWAP=off

PART_ONE="$DISK"1""
PART_TWO="$DISK"2""


  ### Partitioning ###

  # create partitions
parted    $DISK mklabel gpt
parted -s $DISK mkpart primary fat32 1MiB 513MiB
parted -s $DISK mkpart primary ext4 500MiB 100%
parted -s $DISK set 1 boot on
parted -s $DISK name 1 boot
parted -s $DISK name 1 root

  # Setup the encrypted LUKS partition and open it:
cryptsetup luksFormat $PART_TWO
cryptsetup open --type luks $PART_TWO lvm

  # Create two logical volumes
pvcreate /dev/mapper/lvm
vgcreate vg /dev/mapper/lvm

if [ "$SWAP" == "on" ] then;
    lvcreate -L 16G -n swap vg
    mkswap -L swap /dev/vg/swap
    swapon /dev/vg/swap
else
fi

lvcreate -l 100%FREE -n nix vg

  # Format the partitions
mkfs.vfat -n boot $PART_ONE
mkfs.ext4 -L nix /dev/vg/nix


  ### Installing NixOS ###

  # Mounts
mount -t tmpfs none /mnt
mkdir -p /mnt/{boot,home,nix/{nixos,ssh},srv,tmp,var/{lib,log}}
mount $PART_ONE /mnt/boot
mount /dev/vg/nix /mnt/nix
  # Uncomment if it's a fresh install
#mkdir -p /mnt/nix/persist/{root,home,srv,nix/{nixos,ssh},var/{lib,log}}

mount -o bind /mnt/nix/persist/etc/nixos /mnt/etc/nix
mount -o bind /mnt/nix/persist/var/log /mnt/var/log

  # Configure WPA_Supplicant for WIFI
echo "
network={
        ssid="Hal"
        psk=af8dca01536bdf1b08911c118df5971defa78264c21a376fbc41e92f628b6a26
}" >> /etc/wpa_supplicant
systemctl start wpa_supplicant

  # Updating nix-channel
nix-channel --add "https://github.com/NixOS/nixpkgs/archive/master.tar.gz" nixos
nix-channel --add "https://github.com/nix-community/impermanence/archive/master.tar.gz" impermanence
nix-channel --add "https://github.com/nix-community/home-manager/archive/master.tar.gz" home-manager
nix-channel --update

  # Copying NixOS Configs where it's supposed to be
cp -R /home/root/nixos /mnt/nix/persist/etc/nixos

  # Install NixOS
export TMPDIR=/mnt/tmp
nixos-install
