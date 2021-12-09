{ pkgs, lib, ...}: {

  boot = {
    cleanTmpDir = true;
    tmpOnTmpfs = true;
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    loader = {
      timeout = 1;
      grub = {
        enable = true;
        version = 2;
        backgroundColor = "#000000";
        configurationLimit = 30;
        configurationName = "nixos";
        device = lib.mkDefault "/dev/sda";
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
