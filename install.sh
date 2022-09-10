#!/bin/sh
set -e

# Replace with your device
dev=/dev/sdx
swap=on

  ### Partitioning ###

  # create partitions
parted    ${dev} mklabel gpt
parted -s ${dev} mkpart primary fat32 1MiB 501GiB
parted -s ${dev} mkpart primary ext4 501MiB 100%
parted -s ${dev} set 1 boot on
parted -s ${dev} name 1 boot
parted -s ${dev} name 1 nix

  # Create two logical volumes
pvcreate ${dev}2
vgcreate lvm ${dev}2

lvcreate -L 16G lvm -n swap
lvcreate -l 100%FREE lvm -n nix

  # Format the partitions
mkfs.vfat -n boot ${dev}1
mkfs.ext4 -L nix /dev/lvm/nix
mkswap -L swap /dev/lvm/swap
swapon /dev/lvm/swap


  ### Installing NixOS ###

  # Mounts
mount -t tmpfs none /mnt
mkdir -p /mnt/{boot,home,nix,etc/{nixos,ssh},var/{lib,log},srv,tmp}
mount ${dev}1 /mnt/boot
mount /dev/vg/nix /mnt/nix
  # Uncomment if it's a fresh install
mkdir -p /mnt/nix/persist/{home,media,mounts,nix/{nixos,ssh},var/{lib,log},root,srv}

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
nix-channel --update

  # Copying NixOS Configs where it's supposed to be
cp -R /home/root/nix-dotfiles/* /mnt/nix/persist/etc/nixos/.

  # Install NixOS
export TMPDIR=/mnt/tmp

nixos-install
