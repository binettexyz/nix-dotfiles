{ config, pkgs, ... }:
let
  impermanence = builtins.fetchTarball "https://github.com/nix-community/impermanence/archive/master.tar.gz";
in
  {

  users = {
    groups.binette.gid = 1000;
    users.binette = {
      uid = 1000;
      isNormalUser = true;
      createHome = true;
      home = "/nix/persist/home/binette";
      group = "binette";
      extraGroups = [ "wheel" "binette" "users" "audio" "video" ];
      hashedPassword = "$6$sXbE2tHuk9pd63mA$B10NqVR9zqwvod5acnGhK0sYPZ3JiV592PYG.DMswbFEgflfR.QOticvEGFMkLvsENsBUWefDOfR26RUxlRHS0";
      openssh.authorizedKeys.keys = [
        # laptop
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1QoSqbeRihMjTOlRnVIOia/K0FgZvXZlOOJdXDVE54yZ0WxEajYM3n7JgVU+JlvOjUIuzbqLla66YhIG9K2Pixaq4T6PON88aN1E5q2yuJvbu8dNpKrUQY3ZwKbdEzritsJO5YgiC0FqjnllB5SWlu2ZmadXStUV2M2btzqO4v1ZVwEVgJ/cDQe8O7UZWV/jHrPodOWQiTedrFuZPOqmqAcYLV/JEzm6oyxTmhzD6JKsHqjcxM9SAVbqb3TR7/xFzTglnQQ+ueaxcIHnmvSQdR+ii2uFtiNDbtZgQeYk3kZy2gexGrA7MbYb36X/utYKoIlm52GSj1PGGJAN+i0O5jVHIZVi+H4QBVEpaHJ0JucEMq2t3TQb0Uvc9rVxuw8dGxb5rcHmSo4w7hdN1Iwj+KdVv1YaCFoIRUTApTv+3e2fzuTYXzqTxVKNacKGTXEuTHJ1gMJnOUQqTmeDw3SCUVWlHmyZWQTlIq63Ih50ZPw/e3YnpyYu5feE1m7Y4b0= binette@bin-laptop"
      ];
    };
  };

  programs.fuse.userAllowOther = true;

    # packages & programs
  home-manager = {
    useGlobalPkgs = true;
    users.binette = {
      imports = [ "${impermanence}/home-manager.nix" ];

      programs = {
        chromium = {
          enable = true;
#          package = pkgs.ungoogled-chromium;
            # See available extensions at https://chrome.google.com/webstore/category/extensions
          extensions = [
            { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
            { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
            { id = "lckanjgmijmafbedllaakclkaicjfmnk"; } # ClearURLs
            { id = "ldpochfccmkkmhdbclfhpagapcfdljkj"; } # Decentraleyes
            { id = "ahjhlnckcgnoikkfkfnkbfengklhglpg"; } # Dictionary all over with Synonyms
            { id = "oocalimimngaihdkbihfgmpkcpnmlaoa"; } # Netflix Party (Teleparty)
            { id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"; } # Privacy Badger
            { id = "ocgpenflpmgnfapjedencafcfakcekcd"; } # Redirector
            { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # SponsorBlock for YouTube
            { id = "gcbommkclmclpchllfjekcdonpmejbdp"; } # HTTPS Everywhere
          ];
        };
      };

      home = {
        homeDirectory = "/nix/persist/home/binette";
        packages = with pkgs; [
            # browser
          vieb
          brave
            # kindle
          calibre
          calibre-web
            # emails
          mutt-wizard
          neomutt
          isync
          msmtp
          lynx
          notmuch
          abook
          urlview
          mpop
            #rcon
          mcrcon
        ];

        # kde's config
        persistence."/nix/persist/dotfiles/plasma" = {
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

            ".local/share/krunnerstaterc"
            ".local/share/user-places.xbel"
            ".local/share/user-places.xbel.bak"
            ".local/share/user-places.xbel.tbcache"
          ];
        };
      };
    };
  };
}
