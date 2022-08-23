{ config, ... }:

  {
     programs.fuse.userAllowOther = true;

     home-manager.users.binette = {
       imports = [ <impermanence/home-manager.nix> ];
       home.persistence = {
         "/nix/persist/home/binette" = {
           removePrefixDirectory = false;
           allowOther = true;
           directories = [
             ".cache/librewolf"
             ".cache/qutebrowser"
             ".config/dunst"
             ".config/git"
             ".config/lf"
             ".config/mpv"
             ".config/mutt"
             ".config/newsboat"
             ".config/nixpkgs"
             ".config/qutebrowser"
             ".config/shell"
             ".config/x11"

             ".local/bin"
             ".local/share/applications"
             ".local/share/cargo"
             ".local/share/gnupg"
             ".local/share/password-store"
             ".local/share/Ripcord"
             ".local/share/xorg"
             ".local/share/zoxide"
             ".local/share/qutebrowser"

             ".git"
             ".librewolf"
             ".ssh"
             ".gnupg"
             ".zplug"

             "documents"
             "pictures"
             "videos"
             "downloads"
           ];

           files = [
	           ".config/pulse/daemon.conf"
             ".config/greenclip.toml"
             ".config/wall.png"
             ".config/zoomus.conf"
             ".config/mimeapps.list"

             ".local/share/history"

             ".cache/greenclip.history"
           ];
         };
       };
     };
}
