{
  config,
  lib,
  ...
}: {
  imports = [./containers];

  config = lib.mkIf (config.modules.device.type == "server") {
    # ---Network File System---
    services.nfs.server = {
      enable = true;
      exports = ''
        /data 100.102.30.57(rw,insecure,no_subtree_check)
        /data 100.95.71.37(rw,insecure,no_subtree_check)
        /data 100.66.28.9(rw,insecure,no_subtree_check)
      '';
    };

    # ---Docker Container---
    virtualisation = {
      podman = {
        enable = true;
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
            { port = 443; ssl = true; addr = "[::]"; }
            { port = 80; addr = "[::]"; }
            { port = 443; ssl = true; addr = "0.0.0.0"; }
            { port = 80; addr = "0.0.0.0"; }
          ];
          # Avoid any subdomaine being redirect to another vhost.
          rejectSSL = true;
        };
        "jbinette.xyz" = {
          forceSSL = true;
          useACMEHost = "jbinette.xyz";
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
      certs."jbinette.xyz" = {
        domain = "*.jbinette.xyz";
        environmentFile = config.sops.secrets."server/containers/acme-cf-token".path;
      };
    };

    networking = {
      firewall.allowedTCPPorts = [80 443];
      nat = {
        enable = true;
        internalInterfaces = [ "ve-+" ];
        externalInterface = "wlan0";
      };
    };
  };
}
