{ pkgs, ... }: {
  users.users.cath = {
    isNormalUser = true;
    home = "/nix/persist/home/cath";
    group = "users";
    initialPassword = "1234";
  };

  home-manager = {
    useGlobalPkgs = true;
    users.cath.home = {
      homeDirectory = "/nix/persist/home/cath";
      packages = with pkgs; [
#        colord-kde
#        libsForQt5.plasma-desktop
#        libsForQt5.dolphin
#        libsForQt5.plasma-pa
#        libsForQt5.xdg-desktop-portal-kde
#        libsForQt5.kscreen
#        libsForQt5.ffmpegthumbs
#        libsForQt5.kde-gtk-config
#        libsForQt5.breeze-gtk
#        libsForQt5.kdeplasma-addons
#        libsForQt5.kinit
#        libsForQt5.kimageformats
#        libsForQt5.qt5.qtimageformats
      ];
    };
  };
}
