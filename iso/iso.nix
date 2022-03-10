{config, pkgs, lib,  ...}:
{
  imports = [
    <nixpkgs/nixos/modules/profiles/all-hardware.nix>
    <nixpkgs/nixos/modules/profiles/installation-device.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  isoImage.isoName = "NixOS.iso";

  environment.systemPackages = with pkgs; [
      # system stuff
    wipe
    efibootmgr
    parted
    cryptsetup
    mkpasswd
      # editor
    neovim
      # network tools
    rsync
    git
      # file manager
    lf
  ];

  # Enable SSH in the boot process.
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1QoSqbeRihMjTOlRnVIOia/K0FgZvXZlOOJdXDVE54yZ0WxEajYM3n7JgVU+JlvOjUIuzbqLla66YhIG9K2Pixaq4T6PON88aN1E5q2yuJvbu8dNpKrUQY3ZwKbdEzritsJO5YgiC0FqjnllB5SWlu2ZmadXStUV2M2btzqO4v1ZVwEVgJ/cDQe8O7UZWV/jHrPodOWQiTedrFuZPOqmqAcYLV/JEzm6oyxTmhzD6JKsHqjcxM9SAVbqb3TR7/xFzTglnQQ+ueaxcIHnmvSQdR+ii2uFtiNDbtZgQeYk3kZy2gexGrA7MbYb36X/utYKoIlm52GSj1PGGJAN+i0O5jVHIZVi+H4QBVEpaHJ0JucEMq2t3TQb0Uvc9rVxuw8dGxb5rcHmSo4w7hdN1Iwj+KdVv1YaCFoIRUTApTv+3e2fzZuTYXzqTxVKNacKGTXEuTHJ1gMJnOUQqTmeDw3SCUVWlHmyZWQTlIq63Ih50ZPw/e3YnpyYu5feE1m7Y4b0= binette@bin-laptop"
  ];

# Include support for various filesystems.
  boot.supportedFilesystems = [ "btrfs" "vfat" "zfs" "ntfs" ];

  # Configure host id for ZFS to work
  networking.hostId = lib.mkDefault "8425e349";

  system.stateVersion = mkDefault "21.11";
}
