{ pkgs, lib, ... }: {

  services.xserver = {
    windowManager.dwm.enable = lib.mkDefault true;
  };
   home-manager.users.binette.home = {
        packages = with pkgs; [
          dwm-head
          st-head
          dmenu-head
          slstatus-head
        ];
   };

}
