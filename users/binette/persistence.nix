{ config, ... }:
let
  impermanence = builtins.fetchTarball "https://github.com/nix-community/impermanence/archive/master.tar.gz";
in {

     programs.fuse.userAllowOther = true;

       # kde's config
     home-manager.users.binette = {
       imports = [ "${impermanence}/home-manager.nix" ];

       home.persistence."/nix/persist/dotfiles/plasma" = {
         removePrefixDirectory = false;
         allowOther = true;
         directories = [
           ".config/gtk-4.0"
           ".config/kde"
           ".config/kdedefaults"
           ".config/session"
           ".config/xsettingsd"

           ".local/share/baloo"
           ".local/share/dolphin"
           ".local/share/kactivitymanagerd"
           ".local/share/klipper"
           ".local/share/konsole"
           ".local/share/kscreen"
           ".local/share/kwalletd"
           ".local/share/kxmlgui5"
           ".local/share/sddm"
         ];

         files = [
           ".local/share/krunnerstaterc"
           ".local/share/user-places.xbel"
           ".local/share/user-places.xbel.bak"
           ".local/share/user-places.xbel.tbcache"

           ".gtkrc-2.0"
           ".config/akregatorrc"
           ".config/baloofilerc"
           ".config/dolphinrc"
           ".config/gtkrc"
           ".config/gtkrc-2.0"
           ".config/gwenviewrc"
           ".config/kactivitymanagerdrc"
           ".config/kateschemarc"
           ".config/kcminputrc"
           ".config/kconf_updaterc"
           ".config/kded5rc"
           ".config/kdeglobals"
           ".config/kglobalshortcutsrc"
           ".config/khotkeysrc"
           ".config/kmixrc"
           ".config/konsolerc"
           ".config/kscreenlockerrc"
           ".config/ksmserverrc"
           ".config/ktimezonedrc"
           ".config/kwinrc"
           ".config/kwinrulesrc"
           ".config/kxkbrc"
           ".config/plasma-localerc"
           ".config/plasmashellrc"
           ".config/powerdevilrc"
           ".config/powermanagementprofilesrc"
           ".config/spectaclerc"
           ".config/QtProject.conf"
           ".config/spectaclerc"
           ".config/startkderc"
           ".config/systemsettingsrc"
           ".config/Trolltech.conf"
           ".config/user-dirs.dirs"
         ];
       };
     };
}
