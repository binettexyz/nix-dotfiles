{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.server.containers.homer;
  hostAddress = "192.168.100.1";
  localAddress = "192.168.100.18";
  logoDir = "https://raw.githubusercontent.com/binettexyz/nix-dotfiles/master/modules/profiles/server/containers/assets/homer-icons";
  ports.homer = 80;
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

  options.modules.server.containers.homer.enable = lib.mkOption {
    description = "Enable Homer Dashboard";
    default = false;
  };

  config = mkIf (cfg.enable) { 
    services.nginx.virtualHosts."home.jbinette.xyz" = {
      useACMEHost = "jbinette.xyz";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${localAddress}";
      };
      locations."= /assets/custom.css" = {
        alias = cssFile;
      };
    };

    containers.homer = {
      autoStart = true;
      privateNetwork = true;
      hostBridge = "br0";
      inherit localAddress hostAddress;

      config = {pkgs, ...}: {
        system.stateVersion = "25.05";
        networking.firewall.allowedTCPPorts = [ports.homer];

        services.homer = {
          enable = true;
          virtualHost.nginx.enable = true;
          virtualHost.domain = "home.jbinette.xyz";
          settings = {
            title = "kageyami@homelab";
            subtitle = "Self Hosted Services";
            logo = logoDir + "/gruvbox_nwixowos.png";
        
            header = true; # Set to false to hide the header
            footer = false;
            columns = "4";
            connectivityChecker = true;
        
            # Set the default layout and color scheme
            defaults = {
              layout = "columns"; # Either 'columns', or 'list'
              colorTheme = "dark"; # One of 'auto', 'light', or 'dark'
            };
        
            # Optional custom stylesheet
            # Will load custom CSS files. Especially useful for custom icon sets.
            stylesheet = "assets/custom.css";
        
            theme = "default";
            colors = {
              light = {
                highlight-primary = "#2f2f2f";
                highlight-secondary = "#2f2f2f";
                highlight-hover = "#2f2f2f";
                background = "#282828";
                card-background = "#2f2f2f";
                text = "#EBDBB2";
                text-header = "#EBDBB2";
                text-title = "#a89984";
                text-subtitle = "##a89984";
                status-online = "#cc241d";
                status-offline = "#98971a";
              };
         
              dark = {
                highlight-primary = "#2f2f2f";
                highlight-secondary = "#2f2f2f";
                highlight-hover = "#2f2f2f";
                background = "#282828";
                card-background = "#2f2f2f";
                text = "#EBDBB2";
                text-header = "#EBDBB2";
                text-title = "#a89984";
                text-subtitle = "##a89984";
                status-online = "#cc241d";
                status-offline = "#98971a";
              };
            };
            
            #links = null;
    
            services = [
              {
                name = "Media";
                icon = "fas fa-photo-video";
                items = [
                  {
                    name = "Radarr";
                    logo = logoDir + "/radarr.png";
                    url = "http://radarr.jbinette.xyz";
                  }
                  {
                    name = "Sonarr";
                    logo = logoDir + "/sonarr.png";
                    url = "http://sonarr.jbinette.xyz";
                  }
                  {
                    name = "Jellyfin";
                    logo = logoDir + "/jellyfin.png";
                    url = "http://jellyfin.jbinette.xyz";
                  }
                  {
                    name = "Transmission";
                    logo = logoDir + "/transmission.png";
                    url = "http://trans.jbinette.xyz";
                  }
                ];
              }
    
              {
                name = "Services";
                icon = "fas fa-stream";
                items = [
                  {
                    name = "Actual Budget";
                    logo = logoDir + "/actual.png";
                    url = "http://budget.jbinette.xyz";
                  }
                  {
                    name = "Gitea";
                    logo = logoDir + "/gitea.png";
                    url = "http://git.jbinette.xyz";
                  }
                  {
                    name = "Miniflux";
                    logo = logoDir + "/miniflux.png";
                    url = "http://feed.jbinette.xyz";
                  }
                  {
                    name = "Nextcloud";
                    logo = logoDir + "/nextcloud.png";
                    url = "http://cloud.jbinette.xyz";
                  }
                  {
                    name = "Vaultwarden";
                    logo = logoDir + "/bitwarden.png";
                    url = "http://vault.jbinette.xyz";
                  }
                ];
              }
    
              {
                name = "System";
                icon = "fas fa-cog";
                items = [
                  {
                    name = "Jackett";
                    logo = logoDir + "/jackett.png";
                    url = "http://jackett.jbinette.xyz";
                  }
                  {
                    name = "AdGuardHome";
                    logo = logoDir + "/adguardhome.png";
                    url = "http://agh.jbinette.xyz";
                  }
                ];
              }
    
              {        
                name = "Home Automation";
                icon = "fas fa-home";
                items = [
                  {
                    name = "Home Assistant";
                    logo = logoDir + "/home-assistant.png";
                    url = "http://ha.jbinette.xyz";
                  }
                ];
              }
            ];
          };
        };
      };
    };
  };
}

