{ pkgs, lib, ... }:
let
  port = "8080";

  configFile = builtins.toFile "homer-config" (builtins.toJSON {
    title = "server@home";
    subtitle = "Self hosted services";
    logo = "logo.png";

    header = true;
    footer = false;
    columns = 4;
    connectivityCheck = true;

    defaults = { layout = "columns"; colorTheme = "auto"; };
    links = null;

    theme = "default";
#    colors = [
#      {
#        light = {
#          highlight-primary = "#323946";
#          highlight-secondary = "#323946";
#          highlight-hover = "#323946";
#          background = "#2E3440";
#          card-background = "#323946";
#          text = "#81A1C1";
#          text-header = "#81A1C1";
#          text-title = "#D8DEE9";
#          text-subtitle = "#ECEFF4";
#          status-offline = "#BF616A";
#          status-online = "#A3BE8C";
#        };
#      }
#      {
#        dark = {
#          highlight-primary = "#323946";
#          highlight-secondary = "#323946";
#          highlight-hover = "#323946";
#          background = "#2E3440";
#          card-background = "#323946";
#          text = "#81A1C1";
#          text-header = "#81A1C1";
#          text-title = "#D8DEE9";
#          text-subtitle = "#ECEFF4";
#          status-offline = "#BF616A";
#          status-online = "#A3BE8C";
#        };
#      }
#    ];
        services = [
      {
        name = "Media";
        icon = "fas fa-photo-video";
        items = [
          { name = "Radarr"; url = ""; }
          { name = "Sonarr"; url = ""; }
          { name = "Jellyfin"; url = ""; }
          { name = "OpenBooks"; url = ""; }
          { name = "Deluge"; url = ""; }
          { name = "Transmission"; url = ""; }
        ];
      }
      {
        name = "Services";
        icon = "fas fa-stream";
        items = [
          { name = "Nextcloud"; url = ""; }
          { name = "Photoprism"; url = ""; }
          { name = "Bitwarden"; url = ""; }
        ];
      }
      {
        name = "System";
        icon = "fas fa-cog";
        items = [
          { name = "Jackett"; url = ""; }
          { name = "AdGuardHome"; url = ""; }
        ];
      }
      {
        name = "Home Automation";
        icon = "fas fa-home";
        items = [
          { name = "Home Assistant"; url = ""; }
        ];
      }
    ];
#    message = [
#      {
#        style = "is-danger";
#        title = "DuckDuckGo Search Box";
#        icon = "fa fa-exclamation-triangle";
#        content = ''<iframe src="https://duckduckgo.com/search.html?prefill=Search DuckDuckGo&focus=yes&kz=1&kac=1&kn=1&kp=-2&k1=-1" style="overflow:hidden;margin:0;padding:0;width:calc(100% - 100px);height:60px;" frameborder="0"></iframe>'';
#      }
#    ];
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
