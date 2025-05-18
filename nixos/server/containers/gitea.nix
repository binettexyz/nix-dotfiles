{config, lib, ...}:
let
  cfg = config.modules.server.containers.gitea;
  hostAddress = "192.168.100.1";
  localAddress = "192.168.100.14";
  ports.gitea = 3001;
in {

  options.modules.server.containers.gitea.enable = lib.mkOption {
    description = "Enable Gitea";
    default = false;
  };

  config = lib.mkIf cfg.enable {
    services.nginx.virtualHosts."git.jbinette.xyz" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${localAddress}:" + toString (ports.gitea);
        proxyWebsockets = true;
      };
      locations."= /" = {
        extraConfig = ''
          return 302 /explore;
        '';
      };
    };

    sops.secrets."server/containers/gitea-password" = {
      mode = "0400";
      format = "yaml";
    };
  
    containers.gitea =
    let
      passwordFile = "/var/lib/gitea/secret-password";
    in {
      autoStart = true;
      privateNetwork = true;
      hostBridge = "br0";
      inherit localAddress hostAddress;

      bindMounts = {
        "/var/lib/gitea" = {
          hostPath = "/var/lib/gitea";
          isReadOnly = false;
        };
        "/run/secrets/server/containers/gitea-password" = {
          hostPath = config.sops.secrets."server/containers/gitea-password".path;
          isReadOnly = true;
        };
      };

      config = {pkgs, ...}: {
        system.stateVersion = "25.05";

        networking.firewall.allowedTCPPorts = [ 3001 ];

        systemd.tmpfiles.rules = [
          "d /var/lib/gitea 0750 gitea gitea -"
        ];

        systemd.services."prepare-gitea-secret" =
          let
            script = pkgs.writeShellScript "prepare-gitea-secret" ''
              cp /run/secrets/server/containers/gitea-password /var/lib/gitea/secret-password
              chown gitea:gitea /var/lib/gitea/secret-password
              chmod 400 /var/lib/gitea/secret-password
            '';
          in {
          wantedBy = [ "multi-user.target" ];
          before = [ "gitea.service" ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = script;
          };
        };

        services.postgresql = {
          enable = true;
          ensureDatabases = [ config.services.gitea.user ];
          ensureUsers = [{name = config.services.gitea.database.user;}];
        };
      
        services.gitea = {
          enable = true;
          appName = "Binette's Git Repository";
          database = {
            type = "postgres";
            inherit passwordFile;
          };
          settings = {
            server = {
              DOMAIN = "git.jbinette.xyz";
              ROOT_URL = "https://git.jbinette.xyz";
              HTTP_PORT = 3001;
              HTTP_ADDR = "0.0.0.0";
            };
            service = {
              DISABLE_REGISTRATION = true;
              REGISTER_EMAIL_CONFIRM = false;
              REQUIRE_SIGNIN_VIEW = false;
            };
            "service.explore" = {
              REQUIRE_SIGNIN_VIEW = false;
              DISABLE_USERS_PAGE = true;
              DISABLE_ORGANIZATIONS_PAGE = true;
            };
          };
        };
      };
    };
  };

}
