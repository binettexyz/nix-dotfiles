{ pkgs, lib, ... }: {

  services.greenclip.enable = true;
  services.gvfs.enable = lib.mkForce false;

  services.xserver = {
    enable = true;
    layout = "us";
    desktopManager.xterm.enable = false;
    displayManager = {
      startx.enable = lib.mkDefault true;
      lightdm = {
        enable = false;
        background = "/home/binette/pictures/wallpapers/forest.png";
        greeters.enso = {
          enable = true;
          blur = false;
          theme = {
            name = "Dracula";
            package = pkgs.dracula-theme;
          };
          iconTheme = {
            name = "ePapirus";
            package = pkgs.papirus-icon-theme;
          };
          cursorTheme = {
            name = "Vanilla-DMZ";
            package = pkgs.vanilla-dmz;
          };
        };
      };
    };
  };
}
