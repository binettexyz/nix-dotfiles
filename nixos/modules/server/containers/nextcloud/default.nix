{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.containers.nextcloud;
  hostAddress = "10.0.0.15";
  localAddress = "10.0.1.15";
  ports.nextcloud = 8181;
  mkLocalProxy = port: {
    locations."/".proxyPass = "http://${localAddress}";
  };
in
{
  options.modules.containers.nextcloud = {
    enable = mkEnableOption "nextcloud";
  };

  config = mkIf (cfg.enable) { 

    services.nginx.virtualHosts = {
      "nextcloud.box" = mkLocalProxy ports.nextcloud;
    };

    sops.secrets.nextcloud-adminPass = {
      mode = "777";
      format = "yaml";
      sopsFile = ../../secrets.yaml;
    };

    /* ---Main container--- */
    containers.nextcloud =
    let
      adminpassFile = config.sops.secrets.nextcloud-adminPass.path;
      dbPass = config.sops.secrets.nextcloud-dbPass.path;
      datadir = "/var/lib/nextcloud";
    in {
      ephemeral = false;
      autoStart = true;
  
        # networking & port forwarding
      privateNetwork = true;
      inherit localAddress hostAddress;
      forwardPorts = [{ protocol = "tcp"; containerPort = 80; hostPort = 8383; }];

      bindMounts = {
        ${datadir} = { hostPath = "/nix/persist/srv/container-service-data/nextcloud"; isReadOnly = false; };
        ${adminpassFile} = { hostPath = adminpassFile; isReadOnly = true; };
#        ${dbPass} = { hostPath = dbPass; isReadOnly = true; };
#        ${home} = { hostPath = home; isReadOnly = false; };
      };
  
      config = { config, pkgs, ... }: {
          # https://github.com/NixOS/nixpkgs/issues/162686
        networking.nameservers = [ "1.1.1.1" ];
          # WORKAROUND
        environment.etc."resolv.conf".text = "nameserver 1.1.1.1";

        networking.firewall.enable = false;

        services.nextcloud = {
          enable = true;
          package = pkgs.nextcloud23;

          inherit /*home*/ datadir;
          hostName = "nextcloud.box";
#          https = true;

          extraApps = {
            calendar = pkgs.fetchNextcloudApp {
              name = "calendar";
              sha256 = "sha256-c+iiz/pRs7fw2+DneSODWENRnZPZ2BDRa6dOjicABMY=";
              url = "https://github.com/nextcloud/calendar/archive/refs/tags/v3.3.2.tar.gz";
              version = "3.3.2";
            };
            news = pkgs.fetchNextcloudApp {
              name = "news";
              sha256 = "sha256-jmrocdJmRpau0zV8UtLyvrlX/k7O6zlZ8G9zry8ibEw=";
              url = "https://github.com/nextcloud/news/releases/download/18.1.0/news.tar.gz";
              version = "18.1.0";
            };
            deck = pkgs.fetchNextcloudApp {
              name = "deck";
              sha256 = "sha256-qIM6NvOP/1LlIqeQlImmrG6kPHbrF2O1E0yAQCJNDh4=";
              url = "https://github.com/nextcloud/deck/releases/download/v1.7.0/deck.tar.gz";
              version = "1.7.0";
            };
            bookmarks = pkgs.fetchNextcloudApp {
              name = "bookmarks";
              sha256 = "sha256-v3Ug4zdmjWGsFTf6epI4fis6f8rQ43WD65Dy/Ife4kI=";
              url = "https://github.com/nextcloud/bookmarks/releases/download/v10.5.1/bookmarks-10.5.1.tar.gz";
              version = "10.5.1";
            };
          };

#          caching.redis = true;
          config = {
            adminuser = "admin";
#            inherit adminpassFile;
            adminpassFile = "${pkgs.writeText "adminpass" "test123"}";
            dbtype = "pgsql";
            dbhost = "/run/postgresql";
            dbname = "nextcloud";
            dbuser = "nextcloud";
            extraTrustedDomains = [
              "nextcloud.box"
              "10.0.0.103"
              "100.71.254.90"
            ];
#            defaultPhoneRegion = "DE";
#            overwriteProtocol = "https";
          };
        };

        services.postgresql = {
          enable = true;
          package = pkgs.postgresql_14;
          ensureUsers = [
            {
              name = "nextcloud";
              ensurePermissions = {
                "DATABASE nextcloud" = "ALL PRIVILEGES";
              };
            }
          ];
          ensureDatabases = [ "nextcloud" ];
        };

          # ensure that postgres is running *before* running the setup
        systemd.services."nextcloud-setup" = {
          requires = [ "postgresql.service" ];
          after = [ "postgresql.service" ];
        };

        system.stateVersion = "22.11";
      };
    };
  };

}
