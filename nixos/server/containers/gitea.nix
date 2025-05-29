{
  config,
  lib,
  ...
}: let
  cfg = config.modules.server.containers.gitea;
  hostAddress = "192.168.100.1";
  localAddress = "192.168.100.14";
  ports.gitea = 3000;
  ports.ssh = {
    container = 2222;
    host = 22;
  };
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
      extraConfig = ''
        client_max_body_size 512M;
        proxy_set_header Connection $http_connection;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };

    sops.secrets."server/containers/gitea-password" = {
      mode = "0400";
      format = "yaml";
    };

    networking.firewall.allowedTCPPorts = [ports.ssh.host];

    containers.gitea = let
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
      forwardPorts = [
        {
          containerPort = ports.ssh.container;
          hostPort = 22;
          protocol = "tcp";
        }
      ];

      config = {pkgs, ...}: {
        system.stateVersion = "25.05";

        networking.firewall.allowedTCPPorts = [ports.gitea ports.ssh.container];

        systemd.tmpfiles.rules = [
          "d /var/lib/gitea 0750 gitea gitea -"
        ];

        systemd.services."prepare-gitea-secret" = let
          script = pkgs.writeShellScript "prepare-gitea-secret" ''
            cp /run/secrets/server/containers/gitea-password /var/lib/gitea/secret-password
            chown gitea:gitea /var/lib/gitea/secret-password
            chmod 400 /var/lib/gitea/secret-password
          '';
        in {
          wantedBy = ["multi-user.target"];
          before = ["gitea.service"];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = script;
          };
        };

        services.postgresql = {
          enable = true;
          ensureDatabases = [config.services.gitea.user];
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
              HTTP_PORT = ports.gitea;
              HTTP_ADDR = "0.0.0.0";
              START_SSH_SERVER = true;
              SSH_PORT = ports.ssh.host;
              SSH_LISTEN_PORT = ports.ssh.container;
              SSH_DOMAIN = "git.jbinette.xyz";
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
