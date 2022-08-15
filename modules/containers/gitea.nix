{ pkgs, ... }:
{
	networking.firewall.allowedTCPPorts = [ 22 443 ];
	networking.nat.internalInterfaces = [ "ve-gitea" ];

	services.nginx.enable = true;
	services.nginx.virtualHosts."git.alnn.xyz" = {
		serverName = "git.alnn.xyz";
		enableACME = true;
		forceSSL = true;
		locations."/".proxyPass = "http://localhost:3000";
	};

	containers.gitea = {
		config = { config, pkgs, ... }: {
			system.stateVersion = "22.05";

			services.gitea = {
				enable = true;
				cookieSecure = true;
				httpPort = 3000;
				ssh.clonePort = 23;

				rootUrl = "https://git.alnn.xyz/";
				domain = "git.alnn.xyz";
				appName = "git.alnn.xyz: gitea";

				database = {
					type = "postgres";
					passwordFile = "/var/lib/gitea-dbpass";
				};
				/* Mailer disabled until I set-up the mail server 
				mailerPasswordFile = "/var/gitea-mailerpass"; */
				settings = {
					mailer = {
						ENABLED = false;
						FROM = "Gitea <gitea.noreply@alnn.xyz>";
						USER = "gitea.noreply@alnn.xyz";
						MAILER_TYPE = "smtp";
						HOST = "localhost:587";
						IS_TLS_ENABLED = false;
						SKIP_VERIFY = true;
					};
					/* Uncomment when mailer is enabled
					admin.DEFAULT_EMAIL_NOTIFICATIONS = "enabled";
					service = {
						REGISTER_EMAIL_CONFIRM = true;
						ENABLE_MOTIFY_MAIL = true;
					};*/
				};
			};

			services.postgresql = {
				enable = true;
				authentication = "local gitea all ident map=gitea-users";
				identMap = "gitea-users gitea gitea";
			};		
		};
		autoStart = true;
		privateNetwork = true; 
		bindMounts = {
			/* Sharing this path with host as then it's easier to obtain
			   repositories and such */
			"/var/lib/gitea/" = {
				hostPath = "/var/lib/gitea/";
				isReadOnly = false;
			};
		};
		forwardPorts = [
			{
				containerPort = 3000;
				hostPort = 3000;
				protocol = "tcp";
			}
			{
				containerPort = 22;
				hostPort = 23;
				protocol = "tcp";
			}
		];
	};
}
