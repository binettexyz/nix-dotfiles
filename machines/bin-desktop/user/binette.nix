{ config, pkgs, stdenv, ... }:

  {

    services.flatpak.enable = true;
    xdg.portal.enable = true;

    home-manager = {
      useGlobalPkgs = true;
        users.binette = {
          programs.git = {
            enable = true;
            userName = "Binettexyz";
            userEmail = "46168797+Binettexyz@users.noreply.github.com";
            extraConfig = {
              credential.helper = "cache";
            };
          };
          programs.powerline-go.enable = true;

          programs.zsh = {
            enable = true;
            enableAutosuggestions = true;
            enableCompletion = true;
            enableSyntaxHighlighting = true;
          };

            home = {
              username = "binette";
              homeDirectory = "/home/binette";
              packages = with pkgs; [
                  # browser
                brave
                vieb
                nur.repos.sikmir.librewolf
                unstable.zoom-us
                  # media
                discord
                unstable.ripcord
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
                    # kindle
                  calibre calibre-web
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
                betterlockscreen
              ];
            };
          };
        };
      }
