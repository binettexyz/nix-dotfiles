{
  config,
  flake,
  lib,
  pkgs,
  ...
}: let
  service = "nextcloud";
  cfg = config.modules.homelab.services.${service};
  hl = config.modules.homelab;
  hostAddress = "192.168.100.1";
  localAddress = "192.168.100.10";
in {
  options.modules.homelab.services.${service} = {
    enable = lib.mkEnableOption "Enable ${service}";
    address = {
      host = lib.mkOption {
        type = lib.types.str;
        default = "192.168.100.1";
      };
      local = lib.mkOption {
        type = lib.types.str;
        default = "192.168.100.10";
      };
    };
    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/data/${service}";
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "cloud.${hl.baseDomain}";
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx.virtualHosts.${cfg.url} = {
      useACMEHost = hl.baseDomain;
      forceSSL = true;
      locations."/".proxyPass = "http://${cfg.address.local}";
    };

    sops.secrets."server/containers/nextcloud-adminPass" = {
      mode = "777";
      format = "yaml";
    };

    # ---Main Container---
    containers.${service} = let
      adminpassFile = config.sops.secrets."server/containers/nextcloud-adminPass".path;
    in {
      autoStart = true;
      privateNetwork = true;
      localAddress = cfg.address.local;
      hostAddress = cfg.address.host;

      bindMounts = {
        "/var/lib/${service}" = {
          hostPath = cfg.dataDir;
          isReadOnly = false;
        };
        ${adminpassFile} = {
          hostPath = adminpassFile;
          isReadOnly = true;
        };
      };

      config = {pkgs, ...}: {
        system.stateVersion = "25.05";
        networking.firewall.allowedTCPPorts = [80 443];

        networking.useHostResolvConf = lib.mkForce false;
        services.resolved.enable = true;

        services.${service} = {
          enable = true;
          package = pkgs.nextcloud31;
          datadir = "/var/lib/nextcloud";
          hostName = cfg.url;
          https = true;
          config = {
            adminuser = "binette";
            inherit adminpassFile;
            dbtype = "sqlite";
          };
          settings = {
            trusted_proxies = [
              "127.0.0.1"
            ];
            trusted_domains = [
              cfg.url
            ];
            overwriteprotocol = "https";
            overwritehost = cfg.url;
            overwrite.cli.url = "https://${cfg.url}";
          };
          extraApps = {
            inherit
              (pkgs.nextcloud31Packages.apps)
              news
              calendar
              tasks
              ;
          };
          extraAppsEnable = true;
        };
      };
    };
  };
}
