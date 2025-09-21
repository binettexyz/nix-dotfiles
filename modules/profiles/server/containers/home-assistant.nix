{
  config,
  lib,
  ...
}: let
  cfg = config.modules.server.containers.home-assistant;
  hostAddress = "192.168.100.1";
  localAddress = "192.168.100.12";
  ports.home-assistant = 8123;
in {
  options.modules.server.containers.home-assistant.enable = lib.mkOption {
    description = "Enable Home-Assistant";
    default = false;
  };

  config = lib.mkIf cfg.enable {
    services.nginx.virtualHosts."ha.jbinette.xyz" = {
      useACMEHost = "jbinette.xyz";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${localAddress}:" + toString (ports.home-assistant);
      };
      extraConfig = ''
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $http_connection;
      '';
    };

    containers.home-assistant = {
      autoStart = true;
      privateNetwork = true;
      hostBridge = "br0";
      inherit localAddress hostAddress;

      config = {pkgs, ...}: {
        system.stateVersion = "25.05";
        networking.firewall.allowedTCPPorts = [ports.home-assistant];

        services.home-assistant = {
          enable = true;
          extraComponents = [
            # Components required to complete the onboarding
            "esphome"
            "remote_calendar"
          ];
          config = {
            http = {
              use_x_forwarded_for = true;
              trusted_proxies = ["0.0.0.0" "127.0.0.1"];
            };
            # Includes dependencies for a basic setup
            # https://www.home-assistant.io/integrations/default_config/
            default_config = {};
          };
        };
      };
    };

  };
}
