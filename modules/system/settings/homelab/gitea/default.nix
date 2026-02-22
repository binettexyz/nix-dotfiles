{
  flake.nixosModules.gitea =
    { config, lib, ... }:
    let
      service = "gitea";
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
            default = "192.168.100.14";
          };
        };
        port = lib.mkOption {
          type = lib.types.int;
          default = 3000;
        };
        url = lib.mkOption {
          type = lib.types.str;
          default = "git.${baseDomain}";
        };
      };

      config = lib.mkIf cfg.enable {
        services.nginx.virtualHosts."${cfg.url}" = {
          useACMEHost = baseDomain;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://${cfg.address.local}:${toString cfg.port}";
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

        networking.firewall.allowedTCPPorts = [
          22
          cfg.port
        ];

        systemd.tmpfiles.rules = [
          "d ${cfg.serviceDir} 0750 - - -"
        ];

        containers.${service} =
          let
            passwordFile = "/var/lib/gitea/secret-password";
          in
          {
            autoStart = true;
            privateNetwork = true;
            localAddress = cfg.address.local;
            hostAddress = cfg.address.host;

            bindMounts = {
              "/var/lib/gitea" = {
                hostPath = cfg.serviceDir;
                isReadOnly = false;
              };
              "/run/secrets/gitea-password" = {
                hostPath = config.sops.secrets."server/containers/gitea-password".path;
                isReadOnly = true;
              };
            };
            forwardPorts = [
              {
                containerPort = 2222;
                hostPort = 22;
                protocol = "tcp";
              }
            ];

            config =
              { pkgs, ... }:
              {
                system.stateVersion = "25.05";

                networking.firewall.allowedTCPPorts = [
                  cfg.port
                  2222
                ];

                systemd.tmpfiles.rules = [
                  "f /run/secrets/gitea-password"
                  "d /var/lib/gitea 0750 gitea gitea -"
                ];

                systemd.services."prepare-gitea-secret" =
                  let
                    script = pkgs.writeShellScript "prepare-gitea-secret" ''
                      cp /run/secrets/gitea-password /var/lib/gitea/secret-password
                      chown gitea:gitea /var/lib/gitea/secret-password
                      chmod 400 /var/lib/gitea/secret-password
                    '';
                  in
                  {
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
                  ensureUsers = [ { name = config.services.gitea.database.user; } ];
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
                      DOMAIN = cfg.url;
                      ROOT_URL = "https://${cfg.url}";
                      HTTP_PORT = cfg.port;
                      HTTP_ADDR = "0.0.0.0";
                      START_SSH_SERVER = true;
                      SSH_PORT = 22;
                      SSH_LISTEN_PORT = 2222;
                      SSH_DOMAIN = cfg.url;
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
    };
}
