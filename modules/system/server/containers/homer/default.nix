{ pkgs, lib, ... }:
let
  port = "8080";

  configFile = builtins.toFile "homer-config" (builtins.toJSON {
    title = "home@home";
    subtitle = "Self hosted services";
    logo = "logo.png";
    header = true;
    footer = false;
    defaults = {
      layout = "list";
      colorTheme = "dark";
    };
    links = [
      { name = "Logout"; url = "https://auth.h.jackrose.co.nz/logout"; }
    ];
    services = [
      {
        name = "Applications";
        items = [
          { name = "Nextcloud"; subtitle = "File sync and hosting"; url = "https://nextcloud.h.jackrose.co.nz"; }
          { name = "Jellyfin"; subtitle = "Movies and TV"; url = "https://jellyfin.h.jackrose.co.nz"; }
          { name = "Photoprism"; subtitle = "Photos"; url = "https://photoprism.h.jackrose.co.nz"; }
        ];
      }
      {
        name = "*arr";
        items = [
          { name = "Radarr"; subtitle = "Movies"; url = "https://radarr.h.jackrose.co.nz"; }
          { name = "Sonarr"; subtitle = "TV shows"; url = "https://sonarr.h.jackrose.co.nz"; }
          { name = "Prowlarr"; subtitle = "Trackers"; url = "https://prowlarr.h.jackrose.co.nz"; }
        ];
      }
      {
        name = "Admin";
        items = [
          { name = "Traefik dashboard"; subtitle = "Reverse proxy config"; url = "https://traefik.h.jackrose.co.nz"; }
          { name = "Netdata"; subtitle = "OS stats"; url = "https://netdata.h.jackrose.co.nz"; }
          { name = "Authelia"; subtitle = "Just a login page"; url = "https://auth.h.jackrose.co.nz"; }
        ];
      }
    ];
  });
in
{
#  # Can't use utils.mkRoute here because we want the root sub domain
#  services.traefik.dynamicConfigOptions = {
#    http.routers.homer = {
#      rule = "Host(`h.jackrose.co.nz`) || Host(`homer.h.jackrose.co.nz`)";
#      service = "homer";
#      tls.certResolver = "default";
#      middlewares = "authelia@file";
#    };
#    http.services.homer.loadBalancer.servers = [{
#      url = "http://127.0.0.1:${port}";
#    }];
#  };

  virtualisation.oci-containers.containers.homer = {
    autoStart = true;
    image = "b4bz/homer";
    ports = [
      "8080:8080"
    ];
    volumes = [
      "${configFile}:/www/assets/config.yml"
    ];
  };
}
