{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.server.containers.adGuardHome.enable;
  hostAddress = "10.0.0.11";
  localAddress = "10.0.1.11";
  serverIp = "100.69.22.72";
  adguardDir = "/nix/persist/srv/container-service-data/adguardhome";
  unboundDir = "/nix/persist/srv/container-service-data/unbound";
  ports = {
    adguard = 3000;
    adguardDNS = 53;
    unbound = 52;
  };
  mkLocalProxy = port: {
    locations."/".proxyPass = "http://${localAddress}:" + toString(port);
  };
in
{
  options.modules.server.containers.adGuardHome.enable = mkOption {
    description = "Enable AdGuard Home";
    default = false;
  };

  config = mkIf config.modules.server.containers.adGuardHome.enable { 
    services.nginx.virtualHosts = {
      "adguard.box" = mkLocalProxy ports.adguard;
    };

    systemd.tmpfiles.rules = [
      "d ${adguardDir} - - - -"
    ];

    containers.adguardhome = {
      autoStart = true;
      ephemeral = true;

      privateNetwork = true;
      inherit localAddress hostAddress;
  
      bindMounts = {
        "/var/lib/private/AdGuardHome" = { hostPath = adguardDir; isReadOnly = false; };
        "/var/lib/unbound" = { hostPath = unboundDir; isReadOnly = false; };
      };

      forwardPorts = [
# 			 { containerPort = ports.adguard; hostPort = ports.adguard; protocol = "tcp"; }
 			  { containerPort = ports.adguardDNS; hostPort = ports.adguardDNS; protocol = "tcp"; }
 			  { containerPort = ports.adguardDNS; hostPort = ports.adguardDNS; protocol = "udp"; }
      ];

      config = { config, pkgs, ... }: {
      networking.firewall.enable = false;

        services.unbound = {
				  enable = true;
  				settings.server = {
  					interface = [ "127.0.0.1" ];
  					port = ports.unbound;
  					do-ip4 = true;
  					do-ip6 = false;
  					do-udp = true;
  					do-tcp = true;
  
  					prefetch = true;
#  					num-threads = 1;
  					so-rcvbuf = "1m";
  				};
  			};

        services.adguardhome = {
          enable = true;
          openFirewall = false;
          host = "0.0.0.0";
          port = ports.adguard;
          settings = {
            dns = {
              bind_host = "0.0.0.0";
              port = ports.adguardDNS;
              bootstrap_dns = [ "9.9.9.9" ];
              upstream_dns = [
                "127.0.0.1:52"
              ];
  						trusted_proxies = [ "127.0.0.1" ];
              enable_dnssec = true;
              fastest_addr = true;
              rewrites = [
                { domain = "adguard.box"; answer = serverIp; }
                { domain = "hass.box"; answer = serverIp; }
                { domain = "home.box"; answer = serverIp; }
                { domain = "jellyfin.box"; answer = serverIp; }
                { domain = "nextcloud.box"; answer = serverIp; }
                { domain = "vault.box"; answer = serverIp; }
                { domain = "sonarr.box"; answer = serverIp; }
                { domain = "radarr.box"; answer = serverIp; }
                { domain = "jackett.box"; answer = serverIp; }
                { domain = "trans.box"; answer = serverIp; }
              ];
            };
          };
        };

        system.stateVersion = "22.11";
      };
    };
  };

}
