{
  config,
  lib,
  ...
}:
let
  service = "home-assistant";
  cfg = config.modules.homelab.services.${service};
  hl = config.modules.homelab;
  hostAddress = "192.168.100.1";
  localAddress = "192.168.100.12";
  ports.home-assistant = 8123;
in
{
  options.modules.homelab.services.${service} = {
    enable = lib.mkEnableOption "Enable Home-Assistant";
    address = {
      host = lib.mkOption {
        type = lib.types.str;
        default = "192.168.100.1";
      };
      local = lib.mkOption {
        type = lib.types.str;
        default = "192.168.100.12";
      };
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 8123;
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "ha.${hl.baseDomain}";
    };
  };

  config = lib.mkIf (hl.enable && cfg.enable) {
    services.nginx.virtualHosts.${cfg.url} = {
      useACMEHost = hl.baseDomain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${cfg.address.local}:" + toString (cfg.port);
      };
      extraConfig = ''
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $http_connection;
      '';
    };

    containers.${service} = {
      autoStart = true;
      privateNetwork = true;
      localAddress = cfg.address.local;
      hostAddress = cfg.address.host;

      config =
        { pkgs, ... }:
        {
          system.stateVersion = "25.05";
          networking.firewall.allowedTCPPorts = [ cfg.port ];

          services.${service} = {
            enable = true;
            extraComponents = [
              # Components required to complete the onboarding
              "esphome"
              "remote_calendar"
            ];
            config = {
              http = {
                use_x_forwarded_for = true;
                trusted_proxies = [
                  "0.0.0.0"
                  "127.0.0.1"
                ];
              };
              # Includes dependencies for a basic setup
              # https://www.home-assistant.io/integrations/default_config/
              default_config = { };
            };
          };
        };
    };
  };
}
