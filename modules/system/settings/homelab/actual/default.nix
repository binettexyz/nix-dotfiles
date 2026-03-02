{
  flake.nixosModules.actual-budget =
    { config, lib, ... }:
    let
      service = "actual-budget";
      cfg = config.modules.homelab.services.${service};
      baseDomain = config.my.baseDomain;
    in
    {
      options.modules.homelab.services.actual-budget = {
        enable = lib.mkEnableOption "Enable ${service}";
        serviceDir = lib.mkOption {
          type = lib.types.str;
          default = "/nix/persist/srv/${service}";
        };
        address = {
          host = lib.mkOption {
            type = lib.types.str;
            default = "192.168.100.1";
          };
          local = lib.mkOption {
            type = lib.types.str;
            default = "192.168.100.20";
          };
        };
        port = lib.mkOption {
          type = lib.types.int;
          default = 3000;
        };
        url = lib.mkOption {
          type = lib.types.str;
          default = "budget.${baseDomain}";
        };
      };
      config = lib.mkIf cfg.enable {
        services.nginx.virtualHosts.${cfg.url} = {
          useACMEHost = baseDomain;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://${cfg.address.local}:${toString cfg.port}";
          };
        };

        containers.${service} = {
          autoStart = true;
          privateNetwork = true;
          localAddress = cfg.address.local;
          hostAddress = cfg.address.host;

          config = {
            system.stateVersion = "25.05";

            services.actual = {
              enable = true;
              openFirewall = true;
              settings = {
                hostname = "0.0.0.0";
              };
            };
          };
        };
      };
    };
}
