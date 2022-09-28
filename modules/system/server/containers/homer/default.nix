{ config, pkgs, lib, ... }:
with lib;
let
#  sonarrAPI = builtins.readFile /home/binette/documents/sonarrAPI;
#  radarrAPI = builtins.readFile /home/binette/documents/radarrAPI;
  cfg = config.modules.containers.adGuardHome;
  configFile = builtins.toFile "config.yml" ''
    # Homepage configuration
    # See https://fontawesome.com/v5/search for icons options
    
    title: "server@home"
    subtitle: "Self Hosted Services"
    logo: "logo.png"
    
    header: true # Set to false to hide the header
    footer: false
    columns: "4"
    connectivityChecker: true
    
    # Set the default layout and color scheme
    defaults:
      layout: columns # Either 'columns', or 'list'
      colorTheme: dark # One of 'auto', 'light', or 'dark'
    
    # Optional custom stylesheet
    # Will load custom CSS files. Especially useful for custom icon sets.
    stylesheet:
      - "assets/custom.css"
    
    theme: default
    colors:
      light:
        highlight-primary: "#2f2f2f"
        highlight-secondary: "#2f2f2f"
        highlight-hover: "#2f2f2f"
        background: "#282828"
        card-background: "#2f2f2f"
        text: "#EBDBB2"
        text-header: "#EBDBB2"
        text-title: "#a89984"
        text-subtitle: "##a89984"
        status-online: "#cc241d"
        status-offline: "#98971a"
     
      dark:
        highlight-primary: "#2f2f2f"
        highlight-secondary: "#2f2f2f"
        highlight-hover: "#2f2f2f"
        background: "#282828"
        card-background: "#2f2f2f"
        text: "#EBDBB2"
        text-header: "#EBDBB2"
        text-title: "#a89984"
        text-subtitle: "##a89984"
        status-online: "#cc241d"
        status-offline: "#98971a"
    
    links: null
    services:
      - name: "Media"
        icon: "fas fa-photo-video"
        items:
          - name: "Radarr"
            logo: "logo/radarr.png"
            url: "http://100.71.254.90:7878"
            target: "_blank"
#            type: "Radarr"
#            apikey: ""
            type: Ping
          - name: "Sonarr"
            logo: "logo/sonarr.png"
            url: "http://100.71.254.90:8989"
            target: "_blank"
#            type: "Sonarr"
#            apikey: ""
            type: Ping
          - name: "Jellyfin"
            logo: "logo/jellyfin.png"
            url: "http://100.71.254.90:8096"
            target: "_blank"
            type: Ping
          - name: "OpenBooks"
            url: "http://"
            target: "_blank"
            type: Ping
          - name: "Deluge"
            url: "http://"
            target: "_blank"
            type: Ping
          - name: "Transmission"
            logo: "logo/transmission.png"
            url: "http://100.71.254.90:9091"
            target: "_blank"
            type: Ping
    
      - name: "Services"
        icon: "fas fa-stream"
        items:
          - name: "Nextcloud"
            url: "http://"
            target: "_blank"
            type: Ping
          - name: "Photoprism"
            url: "http://"
            target: "_blank"
            type: Ping
          - name: "Bitwarden"
            url: "http://"
            target: "_blank"
            type: Ping
    
      - name: "System"
        icon: "fas fa-cog"
        items:
          - name: "Jackett"
            url: "http://100.71.254.90:9117"
            target: "_blank"
            type: Ping
          - name: "AdGuardHome"
            url: "http://100.71.254.90:80"
            target: "_blank"
            type: Ping
    
      - name: "Home Automation"
        icon: "fas fa-home"
        items:
          - name: "Home Assistant"
            url: "http://"
            target: "_blank"
            type: Ping
    
  '';

  cssFile = builtins.toFile "custom.css" ''
    @charset "UTF-8";
    @import url("https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;600;700&display=swap");
    
    body .no-footer #main-section {
      display: flex;
      flex-grow: 1;
    }
    body #app {
      display: flex;
      flex-direction: column;
    }
    
    footer {
      display: none;
    }
    body,
    h1,
    h2,
    p,
    .title {
      font-family: Open Sans !important;
      font-weight: 400 !important;
    }
    
    p.title {
      font-weight: 700 !important;
    }
    
    nav {
      display: none !important;
    }
    body #bighead .first-line .logo img {
      border-radius: 50%;
    }
    body #app .card,
    body #app .card:hover,
    body #app .message {
      box-shadow: unset;
    }
    body .card {
      box-shadow: unset;
      border-radius: 10px;
    }
    body #app .card {
      border-radius: 10px;
    }
    .status :not(::before) {
      display: none;
    }
    .image.is-48x48 {
      width: 36px;
      height: 36px;
    }
    .status.online,
    .status.offline {
      position: absolute;
      right: 12px;
      font-size: 0 !important;
      color: var(--background) !important;
    }
    .column > div {
      padding-bottom: 1.8em;
    }
    
    .card-content {
      height: 100% !important;
    }
    
    .status.offline::before {
      background-color: var(--status-offline) !important;
      border: unset !important;
      box-shadow: 0 0 5px 1px var(--status-offline) !important;
    }
    
    .status.online::before {
      background-color: var(--status-online) !important;
      border: unset !important;
      box-shadow: 0 0 5px 1px var(--status-online) !important;
    }
  '';
in
{

  options.modules.containers.homer = {
    enable = mkOption {
      description = "Enable Homer dashboard";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) { 

    networking.nat.internalInterfaces = [ "ve-homer" ];
    networking.firewall.allowedTCPPorts = [ 8080 ];
  
    virtualisation.oci-containers.containers.homer = {
      autoStart = true;
      image = "b4bz/homer";
      ports = [
        "8080:8080"
      ];
      volumes = [
        "${configFile}:/www/assets/config.yml"
        "${cssFile}:/www/assets/custom.css"
        "./etc:/www/assets/logo"
      ];
    };
  };
}
