{ config, pkgs, ... }: {

  imports =
   [
     ../../services/net/adguard.nix
     ../../services/net/torrents.nix
     ../../services/net/adguard.nix
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
