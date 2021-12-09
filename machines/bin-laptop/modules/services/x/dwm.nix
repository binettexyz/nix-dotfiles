{ pkgs, lib, user, ... }:

let
  dwm-head = pkgs.callPackage /home/binette/.git/repos/dwm {};
  st-head = pkgs.callPackage /home/binette/.git/repos/st {};
  dmenu-head = pkgs.callPackage /home/binette/.git/repos/dmenu {};
  slstatus-head = pkgs.callPackage /home/binette/.git/repos/slstatus {};
in

  {

    services.xserver = {
      windowManager.dwm.enable = lib.mkDefault true;
    };

    home-manager = {
      users.binette = {
        home = {
          packages = with pkgs; [
            dwm-head
            st-head
            dmenu-head
            slstatus-head
          ];
#          file = {
#            ".config/dunst/dunstrc".source = ../../users/shared/.config/dunst/dunstrc;
#            ".config/twmn/twmn.conf".source = ../../users/shared/.config/twmn/twmn.conf;
#          };
        };
      };
    };

}
