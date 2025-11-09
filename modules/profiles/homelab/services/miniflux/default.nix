{
  config,
  lib,
  ...
}:
let
  service = "miniflux";
  cfg = config.modules.homelab.services.${service};
  hl = config.modules.homelab;
in
{
  options.modules.homelab.services.${service} = {
    enable = lib.mkEnableOption "enable Miniflux";
    address = {
      host = lib.mkOption {
        type = lib.types.str;
        default = "192.168.100.1";
      };
      local = lib.mkOption {
        type = lib.types.str;
        default = "192.168.100.13";
      };
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "feed.${hl.baseDomain}";
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 8080;
    };
  };

  config = lib.mkIf (hl.enable && cfg.enable) {
    services.nginx.virtualHosts.${cfg.url} = {
      useACMEHost = hl.baseDomain;
      forceSSL = true;
      locations."/".proxyPass = "http://${cfg.address.local}:" + toString (cfg.port);
    };

    sops.secrets."server/containers/miniflux-credentials" = {
      mode = "777";
    };
    
    # ---Main container---
    containers.${service} = let
      adminCredentialsFile = config.sops.secrets."server/containers/miniflux-credentials".path;
    in {
      ephemeral = false;
      autoStart = true;
      privateNetwork = true;
      localAddress = cfg.address.local;
      hostAddress = cfg.address.host;

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
        networking.firewall.allowedTCPPorts = [ cfg.port];

        services.${service} = {
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
