{config, lib, pkgs, ... }: {

  networking.nat.internalInterfaces = [ "ve-kodi" ];
  networking.firewall.allowedTCPPorts = [ 80 ];

  containers.kodi = {
    autoStart = true;
      # starts fresh every time it is updated or reloaded
#    ephemeral = true;

      # networking & port forwarding
    privateNetwork = false;
#    hostBridge = "br0";
#    hostAddress = "192.168.100.12";
#    localAddress = "192.168.100.22";

      # mounts
    bindMounts = {
#      "/var/lib/plex" = {
#        hostPath = "/nix/persist/var/lib/plex";
#        isReadOnly = false;
#      };        
      "/media/videos" = {
        hostPath = "/media/videos";
        isReadOnly = false;
      };

    };

    forwardPorts = [
			{
				containerPort = 80;
				hostPort = 80;
				protocol = "tcp";
			}
		];

    config = { config, pkgs, ... }: {

      system.stateVersion = "22.05";
      networking.hostName = "kodi";

      services.nginx = {
        enable = true;
        user = "nginx";
        group = "nginx";

        virtualHosts."kodi.binette" = {
          root = "/media/videos";
          locations."/" = {
            extraConfig = ''
              autoindex on;
              try_files $uri $uri/ =404;
            '';
          };
        };
      };

    };
  };

}
