{ config, pkgs, ... }: {

  services = {
    jackett.enable = true;
    sonarr.enable = true;
    radarr.enable = true;
    plex.enable = true;
  };

#  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    unstable.sonarr
    unstable.radarr
    unstable.jackett
    unstable.plex
  ];
}
