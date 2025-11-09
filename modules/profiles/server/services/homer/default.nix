{ config, pkgs, lib, ... }:
with lib;
let
  service = "homer";
  cfg = config.modules.homelab.services.${service};
  hl = config.modules.homelab;
  logoDir = "https://raw.githubusercontent.com/binettexyz/nix-dotfiles/master/modules/profiles/server/containers/assets/homer-icons";
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

  options.modules.homelab.services.${service} = {
    enable = lib.mkEnableOption "Enable ${service}";
    address = {
      host = lib.mkOption {
        type = lib.types.str;
        default = "192.168.100.1";
      };
      local = lib.mkOption {
        type = lib.types.str;
        default = "192.168.100.18";
      };
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 80;
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "home.${hl.baseDomain}";
    };
  };

  config = mkIf (cfg.enable) { 
    services.nginx.virtualHosts.${cfg.url} = {
      useACMEHost = hl.baseDomain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${cfg.address.local}";
      };
      locations."= /assets/custom.css" = {
        alias = cssFile;
      };
    };

    containers.homer = {
      autoStart = true;
      privateNetwork = true;
      localAddress = cfg.address.local;
      hostAddress = cfg.address.host;

      config = {pkgs, ...}: {
        system.stateVersion = "25.05";
        networking.firewall.allowedTCPPorts = [cfg.port];

        services.${service} = {
          enable = true;
          virtualHost.nginx.enable = true;
          virtualHost.domain = cfg.url;
          settings = {
            title = "genbu@homelab";
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
                    url = "http://radarr.${hl.baseDomain}";
                  }
                  {
                    name = "Sonarr";
                    logo = logoDir + "/sonarr.png";
                    url = "http://sonarr.${hl.baseDomain}";
                  }
                  {
                    name = "Jellyfin";
                    logo = logoDir + "/jellyfin.png";
                    url = "http://jellyfin.${hl.baseDomain}";
                  }
                  {
                    name = "Transmission";
                    logo = logoDir + "/transmission.png";
                    url = "http://trans.${hl.baseDomain}";
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
                    url = "http://budget.${hl.baseDomain}";
                  }
                  {
                    name = "Gitea";
                    logo = logoDir + "/gitea.png";
                    url = "http://git.${hl.baseDomain}";
                  }
                  {
                    name = "Miniflux";
                    logo = logoDir + "/miniflux.png";
                    url = "http://feed.${hl.baseDomain}";
                  }
                  {
                    name = "Nextcloud";
                    logo = logoDir + "/nextcloud.png";
                    url = "http://cloud.${hl.baseDomain}";
                  }
                  {
                    name = "Vaultwarden";
                    logo = logoDir + "/bitwarden.png";
                    url = "http://vault.${hl.baseDomain}";
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
                    url = "http://jackett.${hl.baseDomain}";
                  }
                  {
                    name = "AdGuardHome";
                    logo = logoDir + "/adguardhome.png";
                    url = "http://agh.${hl.baseDomain}";
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
                    url = "http://ha.${hl.baseDomain}";
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

