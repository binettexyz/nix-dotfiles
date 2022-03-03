{ config, lib, ... }: {

  boot = {
    loader = {
      timeout = 1;
      efi = {
        canTouchEfiVariables = lib.mkDefault true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        version = 2;
        device = lib.mkDefault "nodev";
        efiSupport = lib.mkDefault true;
        memtest86.enable = true;
        configurationLimit = lib.mkDefault 30;
        backgroundColor = lib.mkDefault "#000000";
        splashImage = null;
        splashMode = "normal";
        extraConfig = ''
          set menu_color_normal=white/black
          set menu_color_highlight=black/white
        '';
      };
    };
  };
}
