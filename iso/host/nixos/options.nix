{ nixpkgs, config, pkgs, lib, options, ... }: with lib {

  imports =
    [   
        # bootable iso image
      <nixpkgs/nixos/modules/installer/cd-dvd/iso-image.nix>
        # all hardware supported by NixOS
      <nixpkgs/nixos/modules/profiles/all-hardware.nix>
        # Allow "nixos-rebuild" to work properly by providing
        # /etc/nixos/configuration.nix.
      <nixpkgs/nixos/modules/profiles/clone-config.nix>
        # Include a copy of Nixpkgs so that nixos-install works out of
        # the box.
      <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
        # Enable devices which are usually scanned, because we don't know the
        # target system.
      <nixpkgs/nixos/modules/installer/scan/detected.nix>
      <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

    # Adds terminus_font for HiDPI displays
  console.packages = options.console.packages.default ++ [ pkgs.terminus_font ];

    # ISO naming.
  isoImage.isoName = "NixOS.iso";
    # EFI booting
  isoImage.makeEfiBootable = true;
    # USB booting
  isoImage.makeUsbBootable = true;

    # Add Memtest86+ to the CD.
#  boot.loader.grub.memtest86.enable = true;

    # An installation media cannot tolerate a host config defined file
    # system layout on a fresh machine, before it has been formatted.
  swapDevices = mkImageMediaOverride [ ];
  fileSystems = mkImageMediaOverride config.lib.isoFileSystems;

    # Include support for various filesystems.
  boot.supportedFilesystems = [ "btrfs" "vfat" "f2fs" "zfs" "ntfs" ];

    # Configure host id for ZFS to work
  networking.hostId = lib.mkDefault "8425e349";

  boot.postBootCommands = ''
    for o in $(</proc/cmdline); do
      case "$o" in
        live.nixos.passwd=*)
          set -- $(IFS==; echo $o)
          echo "nixos:$2" | ${pkgs.shadow}/bin/chpasswd
          ;;
      esac
    done
  '';

  environment.systemPackages = with pkgs; [
    w3m-nographics # needed for the manual anyway
    testdisk # useful for repairing boot problems
    ms-sys # for writing Microsoft boot sectors / MBRs
    efibootmgr
    efivar
    parted
    gptfdisk
    ddrescue
    ccrypt
    cryptsetup # needed for dm-crypt volumes
    mkpasswd # for generating password files

    # Some text editors.
    neovim

    # Some networking tools.
    rsync
    git

    # Hardware-related tools.
    sdparm
    hdparm
    smartmontools # for diagnosing hard disks
    pciutils
    usbutils

    # Tools to create / manipulate filesystems.
    lf
    wipe
    ntfsprogs # for resizing NTFS partitions
    dosfstools
    mtools
    xfsprogs.bin
    jfsutils
    f2fs-tools

    # Some compression/archiver tools.
    unzip
    zip
  ];

  system.stateVersion = mkDefault "21.11";
}
