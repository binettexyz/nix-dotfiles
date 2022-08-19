{config, lib, pkgs, ... }: {

  networking.nat.internalInterfaces = [ "ve-prowlarr" ];
  networking.firewall.allowedTCPPorts = [ ];

  containers.prowlarr = {
    autoStart = true;
      # starts fresh every time it is updated or reloaded
#    ephemeral = true;

      # networking & port forwarding
    privateNetwork = false;
#    hostBridge = "br0";
#    hostAddress = "192.168.100.10";
#    localAddress = "192.168.100.20";

      # mounts
    bindMounts = {
      "/media/videos" = {
        hostPath = "/media/videos";
        isReadOnly = false;
      };
      "/media/downloads/torrents" = {
        hostPath = "/media/downloads/torrents";
        isReadOnly = false;
      };
    };

    forwardPorts = [
			{
				containerPort = 9696;
				hostPort = 9696;
				protocol = "tcp";
			}
		];

    config = { config, pkgs, ... }: {

      system.stateVersion = "22.05";
      networking.hostName = "prowlarr";

      services.prowlarr = {
        enable = true;
        openFirewall = true;
      };
    };
  };

}