{ config, pkgs, ... }: {

  imports =
   [
     ./../services/net/adguard.nix
     ./../services/net/torrents.nix
     ./../users/server
    ];


    environment.systemPackages = with pkgs; [
      # torrent
    unstable.sonarr
    unstable.radarr
    unstable.jackett
    unstable.plex
    ];

    services = {
      jackett = {
        enable = true;
      };
      sonarr = {
        enable = true;
      };
      radarr = {
        enable = true;
      };
      plex = {
        enable = true;
      };
    };
