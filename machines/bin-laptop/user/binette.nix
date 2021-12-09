{ config, pkgs, stdenv, ... }:

  {

    home-manager = {
      useGlobalPkgs = true;
        users.binette = {
        programs.git = {
          enable = true;
          userName = "Binetto";
          userEmail = "46168797+Binetto@users.noreply.github.com";
          extraConfig = {
            credential.helper = "cache";
          };
        };

            home = {
              username = "binette";
              homeDirectory = "/home/binette";
              packages = with pkgs; [
                  # browser
                brave
                nur.repos.sikmir.librewolf
                qutebrowser
                unstable.zoom-us
                  # media
                discord
                spotify
                  # graphical tools
                geany # editor
                pcmanfm # file manager
                  # audio mixer
                pulsemixer
                unstable.pamixer
                  # Keybind-Manager daemon
                sxhkd
                  # editor
                emacs
                  # tools
                newsboat
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

                unclutter-xfixes # remove mouse wen idle
                unstable.mcrcon # minecraft rcon client
                xcompmgr # compositor (transparency)
                betterlockscreen
              ];
            };
          };
        };
      }
