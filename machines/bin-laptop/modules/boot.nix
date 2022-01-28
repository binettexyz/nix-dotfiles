{ pkgs, lib, ...}: {

  boot = {
    cleanTmpDir = true;
    tmpOnTmpfs = true;
      # luks encryption
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
      # boot loader
    loader = {
      timeout = 1;
      systemd-boot.enable = false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        version = 2;
        enableCryptodisk = true;
        efiSupport = true;
#        useOSProber = true;
        gfxmodeEfi = "1366x768";
        backgroundColor = "#000000";
        configurationLimit = 30;
        configurationName = "nixos-laptop";
        device = "nodev";
        extraConfig = ''
          set menu_color_normal=yellow/black
          set menu_color_highlight=black/yellow
        '';
        splashImage = null;
        splashMode = "normal";

      };
    };
  };
}
