{ config, pkgs, stdenv, ... }:

  {

    home-manager = {
      useGlobalPkgs = true;
        users.cath = {
            home = {
              username = "cath";
              homeDirectory = "/home/cath";
              packages = with pkgs; [
                  # browser
                brave
                  # graphical tools
                geany # editor
                pcmanfm # file manager
                unclutter-xfixes # remove mouse wen idle
              ];
            };
          };
        };
      }
