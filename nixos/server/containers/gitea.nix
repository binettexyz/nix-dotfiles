{config, lib, ...}: {

  options.modules.server.containers.gitea.enable = {
    description = "Enable Gitea";
    default = false;
  };

  config = lib.mkIf cfg.enable {
    services.nginx.virtualHosts."git.jbinette.xyz" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://${localAddress}:" + toString (ports.gitea);
    };

    sops.secrets."server/containers/gitea-password" = {
      mode = "0440";
      format = "yaml";
      owner = "gitea";
    };
  
    containers.gitea = {
      autoStart = true;
      privateNetwork = true;
      hostBridge = true;
      inherit localAddress hostAddress;

      bindMounts = {
        ${} = {
          hostPath = "";
          isReadOnly = false;
        };
      };
    
      config = {...}: {
        systemStateVersion = "25.05";
        services.postgresql = {
          enable = true;
          ensureDatabases = [ config.services.gitea.user ];
          ensureUsers = [{name = config.services.gitea.database.user;}];
        };
      
        services.gitea = {
          enable = true;
          appName = "My awesome Gitea server"; # Give the site a name
          database = {
            type = "postgres";
            passwordFile = config.sops.secrets."server/containers/gitea-password".path;
          };
          settings = {
            server = {
              DOMAIN = "git.jbinette.xyz";
              ROOT_URL = "https://git.jbinette.xyz";
              HTTP_PORT = 3001;
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
