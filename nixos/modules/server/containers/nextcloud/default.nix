{ config, flake, lib, pkgs, ... }:
with lib;

let
  cfg = config.modules.server.containers.nextcloud.enable;
  hostAddress = "10.0.0.15";
  localAddress = "10.0.1.15";
  ports.nextcloud = 8181;
in {

  options.modules.server.containers.nextcloud.enable = mkOption {
    description = "Enable Nextcloud";
    default = false;
  };

  config = lib.mkIf config.modules.server.containers.nextcloud.enable {

    sops.secrets.nextcloud-adminPass = {
      mode = "777";
      format = "yaml";
      sopsFile = ../../secrets.yaml;
    };

    /* ---Main Container--- */
    containers.nextcloud =
      let
        adminpassFile = config.sops.secrets.nextcloud-adminPass.path;
        dbPass = config.sops.secrets.nextcloud-dbPass.path;
        datadir = "/var/lib/nextcloud";
      in {
      autoStart = true;
      privateNetwork = false;
      inherit localAddress hostAddress;
      forwardPorts = [
        { containerPort = 80; hostPort = 80; }
        { containerPort = 442; hostPort = 442; }
      ];

      bindMounts = {
        ${datadir} = { hostPath = "/nix/persist/srv/container-service-data/nextcloud"; isReadOnly = false; };
        ${adminpassFile} = { hostPath = adminpassFile; isReadOnly = true; };
      };

      config = { pkgs, ... }: {
        system.stateVersion = "25.05";
        services.nextcloud = {
          enable = true;
          package = pkgs.nextcloud30;
          inherit datadir;
          hostName = "localhost";
          config = {
            adminuser = "binette";
            inherit adminpassFile;
            #adminpassFile = "${pkgs.writeText "adminpass" "test123"}";
            dbtype = "sqlite";
          };
          settings.trusted_domains = [
            "100.69.22.72"
          ];
          extraApps = {
#             calendar = pkgs.fetchNextcloudApp {
#              name = "calendar";
#              sha256 = "sha256-c+iiz/pRs7fw2+DneSODWENRnZPZ2BDRa6dOjicABMY=";
#              url = "https://github.com/nextcloud/calendar/archive/refs/tags/v3.3.2.tar.gz";
#              version = "3.3.2";
#            };
#            news = pkgs.fetchNextcloudApp {
#              name = "news";
#              sha256 = "sha256-jmrocdJmRpau0zV8UtLyvrlX/k7O6zlZ8G9zry8ibEw=";
#              url = "https://github.com/nextcloud/news/releases/download/18.1.0/news.tar.gz";
#              version = "18.1.0";
#            };
#            deck = pkgs.fetchNextcloudApp {
#              name = "deck";
#              sha256 = "sha256-qIM6NvOP/1LlIqeQlImmrG6kPHbrF2O1E0yAQCJNDh4=";
#              url = "https://github.com/nextcloud/deck/releases/download/v1.7.0/deck.tar.gz";
#              version = "1.7.0";
#            };
#            bookmarks = pkgs.fetchNextcloudApp {
#              name = "bookmarks";
#              sha256 = "sha256-v3Ug4zdmjWGsFTf6epI4fis6f8rQ43WD65Dy/Ife4kI=";
#              url = "https://github.com/nextcloud/bookmarks/releases/download/v10.5.1/bookmarks-10.5.1.tar.gz";
#              version = "10.5.1";
#            };
          };
        };
  
        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [ 80 442 ];
          };
          useHostResolvConf = lib.mkForce false;
        };
  
        services.resolved.enable = true;
      };
    };

  };

}
