{config, lib, pkgs, ... }: {

  networking.nat.internalInterfaces = [ "ve-nginx" ];
  networking.firewall.allowedTCPPorts = [ 80 ];

  containers.nginx = {
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
      networking.hostName = "nginx";

      services.nginx = {
        enable = true;
        user = "nginx";
        group = "nginx";
      };

    };
  };

}
