{
  config,
  flake,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.server.containers.miniflux;
  hostAddress = "192.168.100.1";
  localAddress = "192.168.100.13";
  ports.miniflux = 8080;
in
{
  options.modules.server.containers.miniflux.enable = lib.mkOption {
    description = "enable Miniflux";
    default = false;
  };

  config = lib.mkIf (cfg.enable) {
    services.nginx.virtualHosts."feed.jbinette.xyz" = {
      useACMEHost = "jbinette.xyz";
      forceSSL = true;
      locations."/".proxyPass = "http://${localAddress}:" + toString (ports.miniflux);
    };

    sops.secrets."server/containers/miniflux-credentials" = {
      mode = "777";
    };
    
    # ---Main container---
    containers.miniflux = let
      adminCredentialsFile = config.sops.secrets."server/containers/miniflux-credentials".path;
    in {
      ephemeral = false;
      autoStart = true;
      privateNetwork = true;
      inherit localAddress hostAddress;

      bindMounts = {
        ${adminCredentialsFile} = {
          hostPath = adminCredentialsFile;
          isReadOnly = true;
        };
        "/var/lib/postgresql" = {
          hostPath = "/var/lib/containers/miniflux/postgresql";
          isReadOnly = false;
        };
      };

      config = { pkgs, ... }: {
        system.stateVersion = "22.11";
        networking.firewall.allowedTCPPorts = [ ports.miniflux];

        services.miniflux = {
          enable = true;
          inherit adminCredentialsFile;
          config = {
            LISTEN_ADDR = "0.0.0.0:8080";
          };
        };
      };
    };
  };
}
