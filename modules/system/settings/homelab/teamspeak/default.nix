{
  flake.nixosModules.teamspeak =
    { config, lib, ... }:
    let
      service = "teamspeak";
      cfg = config.modules.homelab.services.${service};
      baseDomain = config.my.baseDomain;
    in
    {
      options.modules.homelab.services.${service} = {
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
        ports = {
          query = lib.mkOption {
            type = lib.types.int;
            default = 10011;
          };
          fileTransfer = lib.mkOption {
            type = lib.types.int;
            default = 30033;
          };
          defaultVoice = lib.mkOption {
            type = lib.types.int;
            default = 9987;
          };
        };
        url = lib.mkOption {
          type = lib.types.str;
          default = "voip.${baseDomain}";
        };
      };

      config = lib.mkIf cfg.enable {
        services.nginx.virtualHosts."${cfg.url}" = {
          useACMEHost = baseDomain;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://${cfg.address.local}:${toString cfg.ports.defaultVoice}";
          };
        };

        systemd.tmpfiles.rules = [
          "d ${cfg.serviceDir} - - - -"
        ];

        containers.${service} = {
          autoStart = true;
          privateNetwork = true;
          localAddress = cfg.address.local;
          hostAddress = cfg.address.host;

          bindMounts = {
            "/var/lib/teamspeak3-server" = {
              hostPath = cfg.serviceDir;
              isReadOnly = false;
            };
          };

          config = {
            system.stateVersion = "25.05";

            networking.firewall.allowedTCPPorts = [
              cfg.ports.query
              cfg.ports.fileTransfer
            ];
            networking.firewall.allowedUDPPorts = [
              cfg.ports.defaultVoice
            ];

            services.teamspeak3 = {
              enable = true;
              openFirewall = true;
              openFirewallServerQuery = true;
              dataDir = "/var/lib/teamspeak3-server";
            };
          };
        };
      };
    };
}
