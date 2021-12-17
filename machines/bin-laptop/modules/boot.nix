{ pkgs, lib, ...}: {

  boot = {
    cleanTmpDir = true;
    tmpOnTmpfs = true;
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    initrd.luks = {
      reusePassphrases = true;
      devices = {
        crypted = {
          device = "/dev/disk/by-uuid/3bdc652b-8ad3-40dc-ae59-bb51370c491a";
	  keyFile = "/dev/disk/by-id/usb-General_UDisk-0:0";
	  keyFileSize = 4096;
          preLVM = true;
	  fallbackToPassword = true;
          bypassWorkqueues = true;
        };
      };
    };
    loader = {
      timeout = 1;
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        enableCryptodisk = true;
        efiSupport = true;
        version = 2;
        backgroundColor = "#000000";
        configurationLimit = 30;
        configurationName = "nixos";
        device = "nodev";
        extraConfig = ''
          set menu_color_normal=yellow/black
          set menu_color_highlight=black/yellow
        '';
        splashImage = null;
#        splashImage = ../assets/Season-01-Gas-station-by-dutchtide.png;
#        splashMode = "stretch";

          # use "blkdid" command to set UUID of your partition
#        extraEntries = ''
#          menuentry "NAME-HERE" {
#          search --set=myroot --fs-uuid <UUID-HERE>
#          configfile "(Smyroot)/boot/grub/grub.cfg"
#          }
#        '';
      };
    };
  };
}
