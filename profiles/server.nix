{ config, pkgs, lib, ... }: {

  imports =
   [
     ../services/net/adguard.nix
     ../services/net/torrents.nix
     ../users/server
     ../users/shared
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

      # don't install documentation i don't use
    documentation.enable = lib.mkForce false; # documentation of packages
    documentation.nixos.enable = lib.mkForce false; # nixos documentation
    documentation.man.enable = lib.mkForce true; # manual pages and the man command
    documentation.info.enable = lib.mkForce false; # info pages and the info command
    documentation.doc.enable = lib.mkForce false; # documentation distributed in packages' /share/doc


}
