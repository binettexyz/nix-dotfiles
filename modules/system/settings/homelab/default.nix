{ inputs, ... }:
{
  flake.nixosModules.homelab =
    { config, lib, ... }:
    let
      cfg = config.modules.homelab.services;
      baseDomain = config.my.baseDomain;
    in
    {
      options.modules.homelab.services = {
        #enable = lib.mkEnableOption "Enable Services & settings for homelab";
        docker.enable = lib.mkEnableOption "Enable Docker";
        nfs.enable = lib.mkEnableOption "Enable NFS";
      };

      imports = with inputs.self.nixosModules; [
        cloudflareDDNS
        gitea
        homer
        ha
        immich
        jellyfin
        miniflux
        nextcloud
        servarr
        vaultwarden
      ];

      config = {
        #---NAT---
        networking = {
          firewall.allowedTCPPorts = [
            80
            443
          ];
          nat = {
            enable = true;
            internalInterfaces = [ "ve-+" ];
            externalInterface = config.networking.defaultGateway.interface;
          };
        };

        # ---NFS---
        services.nfs.server = {
          enable = cfg.nfs.enable;
          # byakko
          exports = ''
            /home/data 100.114.180.61(rw,insecure,no_subtree_check)
          '';
        };

        # ---Docker Container---
        virtualisation = {
          podman = {
            enable = cfg.docker.enable;
            dockerCompat = true;
            enableNvidia = lib.mkDefault false;
            autoPrune.enable = true;
          };
          oci-containers.backend = "podman";
        };

        # ---Nginx---
        services.nginx = {
          enable = true;
          virtualHosts = {
            "default" = {
              # Set this vhost as the default.
              default = true;
              listen = [
                {
                  port = 443;
                  ssl = true;
                  addr = "[::]";
                }
                {
                  port = 80;
                  addr = "[::]";
                }
                {
                  port = 443;
                  ssl = true;
                  addr = "0.0.0.0";
                }
                {
                  port = 80;
                  addr = "0.0.0.0";
                }
              ];
              # Avoid any subdomaine being redirect to another vhost.
              rejectSSL = true;
            };
            "${baseDomain}" = {
              forceSSL = true;
              useACMEHost = baseDomain;
              locations."/".extraConfig = ''
                default_type text/plain;
                return 200 "Root domain reserved.";
              '';
            };
          };
        };

        users.users.nginx.extraGroups = [ "acme" ];
        # Always use Nginx
        services.httpd.enable = lib.mkForce false;
        # Override the user and group to match the Nginx ones
        # Since some services uses the httpd user and group
        services.httpd = {
          user = lib.mkForce config.services.nginx.user;
          group = lib.mkForce config.services.nginx.group;
        };

        # ---ACME Certs---
        sops.secrets."server/containers/acme-cf-token" = {
          mode = "0400";
        };
        security.acme = {
          acceptTerms = true;
          defaults = {
            reloadServices = [ "nginx" ];
            email = "binettexyz@proton.me";
            group = config.services.nginx.group;
            dnsProvider = "cloudflare";
            dnsPropagationCheck = true;
          };
          certs."${baseDomain}" = {
            domain = "*.${baseDomain}";
            environmentFile = config.sops.secrets."server/containers/acme-cf-token".path;
          };
        };
      };
    };
}
