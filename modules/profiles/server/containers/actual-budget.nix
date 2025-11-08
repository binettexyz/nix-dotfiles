{
  config,
  lib,
  ...
}: let
  cfg = config.modules.server.containers.actual-budget;
  hostAddress = "192.168.100.1";
  localAddress = "192.168.100.16";
  ports.actual-budget = 3000;
in {
  options.modules.server.containers.actual-budget.enable = lib.mkOption {
    description = "Enable Home-Assistant";
    default = false;
  };

  config = lib.mkIf cfg.enable {
    services.nginx.virtualHosts."budget.jbinette.xyz" = {
      useACMEHost = "jbinette.xyz";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${localAddress}:" + toString (ports.actual-budget);
      };
    };

    containers.actual-budget = {
      autoStart = true;
      privateNetwork = true;
      inherit localAddress hostAddress;

      config = {pkgs, ...}: {
        system.stateVersion = "25.05";
        networking.firewall.allowedTCPPorts = [ports.actual-budget];

        services.actual = {
          enable = true;
          settings = {
            hostname = "0.0.0.0";
          };
        };
      };
    };
  };
}
