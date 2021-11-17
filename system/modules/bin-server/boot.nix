{ config, pkgs, ...}: {

  boot = {
    cleanTmpDir = false;
    kernelPackages = pkgs.linuxPackages_5_14;
    loader = {
      grub.enable = false;
      systemd-boot.enable = true;
      efi.cantouchEfiVariables = true;
    };

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
