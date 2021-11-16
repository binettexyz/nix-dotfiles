{ config, pkgs, ...}:

let

  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
    { config = config.nixpkgs.config; allowUnfree = true; };

in {

  boot = {
    cleanTmpDir = false;
    kernelPackages = pkgs.linuxPackages_5_14;
    plymouth.enable = true;
    loader.grub = {
      enable = true;
      version = 2;
      configurationName = "nixos";
      device = "/dev/sda";
        # use "blkdid" command to set UUID of your partition
#      extraEntries = ''
#        menuentry "NAME-HERE" {
#        search --set=myroot --fs-uuid <UUID-HERE>
#        configfile "(Smyroot)/boot/grub/grub.cfg"
#        }
#      '';
    };
  };
}
