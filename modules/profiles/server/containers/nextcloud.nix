{
  config,
  flake,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.server.containers.nextcloud.enable;
  hostAddress = "192.168.100.1";
  localAddress = "192.168.100.10";
in {
  options.modules.server.containers.nextcloud.enable = lib.mkOption {
    description = "Enable Nextcloud";
    default = false;
  };

  config = lib.mkIf config.modules.server.containers.nextcloud.enable {
    services.nginx.virtualHosts."cloud.jbinette.xyz" = {
      useACMEHost = "jbinette.xyz";
      forceSSL = true;
      locations."/".proxyPass = "http://${localAddress}";
    };

    sops.secrets."server/containers/nextcloud-adminPass" = {
      mode = "777";
      format = "yaml";
    };

    # ---Main Container---
    containers.nextcloud = let
      adminpassFile = config.sops.secrets."server/containers/nextcloud-adminPass".path;
      datadir = "/var/lib/nextcloud";
    in {
      autoStart = true;
      privateNetwork = true;
      hostBridge = "br0";
      inherit localAddress hostAddress;

      bindMounts = {
        ${datadir} = {
          hostPath = "/data/nextcloud";
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

        services.nextcloud = {
          enable = true;
          package = pkgs.nextcloud31;
          inherit datadir;
          hostName = "cloud.jbinette.xyz";
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
              "cloud.jbinette.xyz"
            ];
            overwriteprotocol = "https";
            overwritehost = "cloud.jbinette.xyz";
            overwrite.cli.url = "https://cloud.jbinette.xyz";
          };
          extraApps = {
            inherit
              (pkgs.nextcloud30Packages.apps)
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
