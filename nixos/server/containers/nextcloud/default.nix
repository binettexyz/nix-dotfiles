{
  config,
  flake,
  lib,
  pkgs,
  ...
}:
with lib;

let
  cfg = config.modules.server.containers.nextcloud.enable;
  hostAddress = "192.168.100.1";
  localAddress = "192.168.100.10/24";
  ports.nextcloud = 8181;
  mkLocalProxy = port: {
    locations."/".proxyPass = "http://${localAddress}:" + toString (port);
  };
in
{

  options.modules.server.containers.nextcloud.enable = mkOption {
    description = "Enable Nextcloud";
    default = false;
  };

  config = lib.mkIf config.modules.server.containers.nextcloud.enable {
    services.nginx.virtualHosts = {
      "nextcloud.box" = mkLocalProxy ports.nextcloud;
    };

    sops.secrets."server/containers/nextcloud-adminPass" = {
      mode = "777";
      format = "yaml";
    };

    # ---Main Container---
    containers.nextcloud =
      let
        adminpassFile = config.sops.secrets."server/containers/nextcloud-adminPass".path;
        datadir = "/var/lib/nextcloud";
      in
      {
        autoStart = true;
        privateNetwork = true;
        hostBridge = "br0";
        inherit localAddress hostAddress;
        forwardPorts = [
          {
            containerPort = 80;
            hostPort = ports.nextcloud;
          }
          {
            containerPort = 442;
            hostPort = 442;
          }
        ];

        bindMounts = {
          ${datadir} = {
            hostPath = "/media/nextcloud";
            isReadOnly = false;
          };
          ${adminpassFile} = {
            hostPath = adminpassFile;
            isReadOnly = true;
          };
        };

        config =
          { pkgs, ... }:
          {
            system.stateVersion = "25.05";
            services.nextcloud = {
              enable = true;
              package = pkgs.nextcloud31;
              inherit datadir;
              hostName = "localhost";
              config = {
                adminuser = "binette";
                inherit adminpassFile;
                dbtype = "sqlite";
              };
              settings.trusted_domains = [
                "100.110.153.50"
              ];
              extraApps = {
                inherit (pkgs.nextcloud30Packages.apps)
                  news
                  contacts
                  calendar
                  tasks
                  mail
                  bookmarks
                  notes
                  ;
              };
              extraAppsEnable = true;
            };

            networking = {
              firewall = {
                enable = true;
                allowedTCPPorts = [
                  ports.nextcloud
                  80
                  442
                ];
              };
              useHostResolvConf = lib.mkForce false;
            };

            services.resolved.enable = true;
          };
      };

  };

}
